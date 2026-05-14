class SubjectsController < ApplicationController
  before_action :set_subject, only: %i[ show edit update destroy ]

  # GET /subjects or /subjects.json
  def index
    @subjects = current_user.subjects
  end

  # GET /subjects/1 or /subjects/1.json
  def show
  end

  # GET /subjects/new
  def new
    @subject = current_user.subjects.new
  end

  # GET /subjects/1/edit
  def edit
  end

  # POST /subjects or /subjects.json
  def create
    @subject = current_user.subjects.new(subject_params)

    respond_to do |format|
      if @subject.save
        format.html { redirect_to @subject, notice: "Subject was successfully created." }
        format.json { render :show, status: :created, location: @subject }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subjects/1 or /subjects/1.json
  def update
    respond_to do |format|
      if @subject.update(subject_params)
        format.html { redirect_to @subject, notice: "Subject was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @subject }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @subject.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subjects/1 or /subjects/1.json
  def destroy
    @subject.destroy!

    respond_to do |format|
      format.html { redirect_to subjects_path, notice: "Subject was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  def generate_lessons
    #@subject = current_user.subjects.find(params[:id])
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])

    if @subject.generate_lessons!(start_date, end_date)
      redirect_to @subject, notice: "Lessons successfully generated!"
    else
      redirect_to @subject, alert: "Generation failed."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subject
      @subject = current_user.subjects.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def subject_params
      params.expect(subject: [ :name, :group, :room, :schedule_data ])
    end
end
