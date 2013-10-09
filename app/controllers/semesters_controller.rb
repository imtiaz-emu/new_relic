class SemestersController < ApplicationController
  before_action :set_semester, only: [:show, :edit, :update, :destroy]
  http_basic_authenticate_with name: "1", password: "1", except: [:index, :show]

  # GET /semesters
  # GET /semesters.json
  def index
    @semesters = Semester.all
  end

  # GET /semesters/1
  # GET /semesters/1.json
  def show
  end

  # GET /semesters/new
  def new
    @semester = Semester.new
  end

  # GET /semesters/1/edit
  def edit
  end

  # POST /semesters
  # POST /semesters.json
  def create
    @semester = Semester.new(semester_params)

    respond_to do |format|
      if @semester.save
        format.html { redirect_to @semester, notice: 'Semester was successfully created.' }
        format.json { render action: 'show', status: :created, location: @semester }
      else
        format.html { render action: 'new' }
        format.json { render json: @semester.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /semesters/1
  # PATCH/PUT /semesters/1.json
  def update
    respond_to do |format|
      if @semester.update(semester_params)
        format.html { redirect_to @semester, notice: 'Semester was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @semester.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /semesters/1
  # DELETE /semesters/1.json
  def destroy
    @semester.destroy
    respond_to do |format|
      format.html { redirect_to semesters_url }
      format.json { head :no_content }
    end
  end

  def get_drop_down_options

    val = params[:id]
    semester = Semester.find(params[:id])
    subject = semester.subjects
    #Use val to find records
    @subject_options = subject.collect { |x| "#{x.subject_name}" }

    id_card = params[:user_id]
    @previous_subjects = []
    registration = Registration.find_all_by_semester_no(val)
    @registration = registration
    @registration.each do |element|
      if element.student_id_card == id_card
        @subject_options.delete(element.subject_name)
        @previous_subjects.push(element.subject_name)
      end
    end

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_semester
    @semester = Semester.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def semester_params
    params.require(:semester).permit(:semester_no)
  end
end
