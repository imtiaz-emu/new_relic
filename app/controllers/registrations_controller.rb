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
    @subject_options = []
  end

  # GET /registrations/1/edit
  def edit
    @registration = Registration.find(params[:id])
    semester = Semester.find(@registration.semester_no)           #find subjects from SUBJECT table based on semester_no
    subject = semester.subjects
    @subject_options = subject.collect { |x| "#{x.subject_name}" }
    @previous_subjects = []
    @register = Registration.all
    @register.each do |element|
      if element.student_id_card == @registration.student_id_card
        if element.semester_no == @registration.semester_no
          @subject_options.delete(element.subject_name)
          @previous_subjects.push(element.subject_name)
        end
      end
    end
  end

  # POST /registrations
  # POST /registrations.json
  def create
    @registration = Registration.new(registration_params)
    unless @registration.semester_no.blank?
    semester = Semester.find(@registration.semester_no)             #find subjects from SUBJECT table based on semester_no
    subject = semester.subjects
    else err = true
    end
    #Use val to find records
    @previous_subjects = []                                         #subjects that are already taken to this semester
    @subject_options = subject.collect { |x| "#{x.subject_name}" }  #subjects available to take in this semester
    @register = Registration.all
    @register.each do |element|                                     #listing the available & editable subjects
      if element.student_id_card == @registration.student_id_card
        if element.semester_no == @registration.semester_no
          @subject_options.delete(element.subject_name)
          @previous_subjects.push(element.subject_name)
        end
      end
    end

    previous_subjects = @previous_subjects

    # finding the subjects belongs to the unique ID card holder student & for a specific semester
    student_id_no = @registration.student_id_card
    semester_no = @registration.semester_no
    subject_nam = @registration.subject_name

    unless (subject_nam.blank?)                                     # check which subjects to add/destroy in/from the DB
      subjects_to_add = subject_nam - previous_subjects
      subjects_to_destroy = previous_subjects - subject_nam
    else
      subjects_to_destroy = previous_subjects
      subjects_to_add = nil
    end

    # adding the subjects
    err = false
    unless subjects_to_add.blank?
      temp_subject = []
      subjects_to_add.each do |subject|
        @registration = Registration.new({semester_no: semester_no, student_id_card: student_id_no, subject_name: subject})
        if @registration.save
          temp_subject.push (subject)
        else
          err = true
        end
      end
      temp_subject.each do |subject|
        @subject_options.delete(subject)
        @previous_subjects.push(subject)
      end
    end

    # deleting the subjects
    unless subjects_to_destroy.blank?
      temp_subject = []
      subjects_to_destroy.each do |subject|
        Registration.destroy_all(:student_id_card => student_id_no, :semester_no => semester_no, :subject_name => subject)
        temp_subject.push(subject);
      end
      temp_subject.each do |subject|
        @previous_subjects.delete(subject)
        @subject_options.push(subject)
      end
    end

    respond_to do |format|
      if !err
        if subject_nam.blank?
          format.html { redirect_to action: 'index', notice: 'Register was successfully updated.' }
        else
          format.html { redirect_to action: 'index', notice: 'Register was successfully updated.' }
        end

        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @registration.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /registrations/1
  # PATCH/PUT /registrations/1.json
  def update
    @registration = Registration.find(params[:id])

    semester = Semester.find(@registration.semester_no) #find subjects from SUBJECT table based on semester_no
    subject = semester.subjects
                                                        #Use val to find records
    @previous_subjects = []
    @subject_options = subject.collect { |x| "#{x.subject_name}" }
    @register = Registration.all
    @register.each do |element|
      if element.student_id_card == @registration.student_id_card
        if element.semester_no == @registration.semester_no
          @subject_options.delete(element.subject_name)
          @previous_subjects.push(element.subject_name)
        end
      end
    end

    previous_subjects = @previous_subjects

    # finding the subjects belongs to the unique ID card holder student & for a specific semester
    student_id_no = @registration.student_id_card
    semester_no = params[:registration][:semester_no]
    subject_nam = params[:registration][:subject_name]

    unless (subject_nam.blank?)
      subjects_to_add = subject_nam - previous_subjects
      subjects_to_destroy = previous_subjects - subject_nam
    else
      subjects_to_destroy = previous_subjects
      subjects_to_add = nil
    end

    # adding the subjects
    err = false
    unless subjects_to_add.blank?
      temp_subjects = []
      subjects_to_add.each do |subject|
        @registration = Registration.new({semester_no: semester_no, student_id_card: student_id_no, subject_name: subject})
        if @registration.save
          temp_subjects.push (subject)
        else
          err = true
        end
      end
      temp_subjects.each do |subject|
        @subject_options.delete(subject)
        @previous_subjects.push(subject)
      end
    end

    # deleting the subjects
    unless subjects_to_destroy.blank?
      temp_subjects = []
      subjects_to_destroy.each do |subject|
        Registration.destroy_all(:student_id_card => student_id_no, :semester_no => semester_no, :subject_name => subject)
        temp_subjects.push(subject);
      end
      temp_subjects.each do |subject|
        @previous_subjects.delete(subject)
        @subject_options.push(subject)
      end
    end

    respond_to do |format|
      if !err
        if subject_nam.blank?
          format.html { redirect_to action: 'index', notice: 'Register was successfully updated.' }
        else
          format.html { redirect_to action: 'index', notice: 'Register was successfully updated.' }
        end

        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @registration.errors, status: :unprocessable_entity }
      end
    end
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
    params.require(:registration).permit(:student_id_card, :semester_no, {:subject_name => []})
  end
end
