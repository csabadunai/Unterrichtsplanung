class PhasesController < ApplicationController
  before_action :set_lesson
  before_action :set_phase, only: %i[ show edit update destroy move_lower move_higher ]

  def index
    # We already have @lesson from before_action. 
    # Scope phases to this lesson specifically.
    @phases = @lesson.phases.order(:position)
  end

  def new
    # Use the association to build the phase so lesson_id is pre-set
    new_position = params[:position] || (@lesson.phases.maximum(:position).to_i + 1)
    @phase = @lesson.phases.build(position: new_position)
  end

  def create
    bulk_params = params[:phases]
    attributes = if bulk_params.is_a?(Array)
                   bulk_params.first
                 elsif bulk_params.is_a?(Hash)
                   bulk_params.values.first
                 end

    safe_attributes = attributes ? attributes.permit(:duration, :social, :description, :differentiation, :materials, :position) : phase_params

    # Build through @lesson to ensure foreign key is set
    @phase = @lesson.phases.build(safe_attributes)

    if @phase.save
      redirect_to lesson_phases_path(@lesson, editing: true), notice: "Phase inserted."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @phase.update(phase_params)
      redirect_to lesson_phases_path(@lesson, editing: params[:editing]), notice: "Phase updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def bulk_update
    params[:phases].each do |id, attributes|
      # Safety: only find phases belonging to THIS lesson
      phase = @lesson.phases.find(id)
      safe_attributes = attributes.permit(:duration, :social, :description, :differentiation, :materials, :position)
      phase.update(safe_attributes)
    end

    redirect_to lesson_phases_path(@lesson), notice: "All phases updated."
  end

  def move_higher
    @phase.move_higher
    redirect_to lesson_phases_path(@lesson, editing: params[:editing])
  end

  def move_lower
    @phase.move_lower
    redirect_to lesson_phases_path(@lesson, editing: params[:editing])
  end

  def destroy
    @phase.destroy!
    redirect_to lesson_phases_path(@lesson), status: :see_other
  end

  private

  def set_lesson
    @lesson = Lesson.find(params[:lesson_id])
  end

  def set_phase
    # Scoping this lookup to @lesson provides extra security
    @phase = @lesson.phases.find(params[:id])
  end

  def phase_params
    params.expect(phase: [ :duration, :social, :description, :differentiation, :materials, :position ])
  end
end
