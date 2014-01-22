class RegistrationsController < ApplicationController
  before_action :set_registration, only: [:show, :edit, :update, :destroy]

  # GET /registrations
  # GET /registrations.json
  def index
    @registrations = Registration.all
  end

  # GET /registrations/1
  # GET /registrations/1.json
  def show
  end

  # GET /registrations/new
  def new
    @registration = Registration.new
    @subject = Subject.all
    @semester = Semester.all
    @student = Student.all
    @subject_options = []
  end

  # GET /registrations/1/edit
  def edit

    @registration = Registration.find(params[:id])
    semester = Semester.find(@registration.semester_id) #find subjects from SUBJECT table based on semester_no
    subject = semester.subjects
    student = Student.find(@registration.student_id).id
    @subject_options = subject.collect { |x| "#{x.id}" }
    @previous_subjects = []
    @register = Registration.all
    @register.each do |element|
      if element.student_id == student
        if element.semester_id == @registration.semester_id
          unless @previous_subjects.include?(element.subject_id)
            @previous_subjects.push(element.subject_id)
          end
        end
      end
    end

    @previous_subjects.each do |subject|
      if @subject_options.include?(subject)
        @subject_options.delete(subject)
      end
    end

  end

  # POST /registrations
  # POST /registrations.json
  def create
    @registration = Registration.new(registration_params)
    err = false

    if Student.find_by_name(params[:registration][:student_id])
      student = Student.find_by_name(params[:registration][:student_id]).id
    else
      err = true
    end

    if !err
      err = @registration.save_registration(params[:registration], student)
    end

    if err
      redirect_to new_registration_path
    else
      redirect_to registrations_path
    end

  end

  # PATCH/PUT /registrations/1
  # PATCH/PUT /registrations/1.json
  def update
    @registration = Registration.find(params[:id])
    student = Student.find(@registration.student_id).id
    err = @registration.save_registration(params[:registration], student)
    redirect_to registrations_path
  end

  # DELETE /registrations/1
  # DELETE /registrations/1.json
  def destroy
    @registration.destroy
    respond_to do |format|
      format.html { redirect_to registrations_url }
      format.json { head :no_content }
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_registration
    @registration = Registration.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def registration_params
    params.require(:registration).permit(:student_id, :semester_id, {:subject_id => []})
  end
end