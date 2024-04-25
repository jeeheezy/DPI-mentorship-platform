class ProgramsController < ApplicationController
  before_action :set_program, only: %i[ show edit update destroy]
  before_action { authorize(@program || Program)}

  # GET /programs or /programs.json
  def index
    @programs = Program.all.order(created_at: :asc).includes([:banner_image_attachment, :owner])
  end

  # GET /programs/1 or /programs/1.json
  def show
    @mentors = @program.participations.where(role: "mentor").includes([:user], user: { profile_picture_attachment: :blob })
    @mentees = @program.participations.where(role: "mentee").includes([:user], user: { profile_picture_attachment: :blob })
    @participation = @program.participations.find_by(user_id: current_user.id)
    if @participation&.mentee?
      if @participation.rankings.empty?
        @rankings = 5.times.map { @participation.rankings.build }
      else
        @rankings = @participation.rankings.order(rank: :asc)
      end
    end
  end

  # GET /programs/new
  def new
    @program = Program.new
  end

  # GET /programs/1/edit
  def edit
  end

  # POST /programs or /programs.json
  def create
    Program.transaction do 
      @program = Program.new(program_params)
      @program.owner_id = current_user.id
      respond_to do |format|
        if @program.save!
          Participation.create!(user_id: current_user.id, program_id: @program.id, role: "admin")
          format.html { redirect_to program_url(@program), notice: "Program was successfully created." }
          format.json { render :show, status: :created, location: @program }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @program.errors, status: :unprocessable_entity }
        end
      end
    end
    rescue ArgumentError => e
      respond_to do |format|
        format.html { redirect_to new_program_url(program_id: @program), alert: e.message }
        format.json { render json: { error: e.message }, status: :unprocessable_entity }
      end
    rescue ActiveRecord::RecordInvalid => e
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity, alert: e.message }
        format.json { render json: e.message, status: :unprocessable_entity }
      end
  end

  # PATCH/PUT /programs/1 or /programs/1.json
  def update
    respond_to do |format|
      if @program.update(program_params)
        format.html { redirect_to program_url(@program), notice: "Program was successfully updated." }
        format.json { render :show, status: :ok, location: @program }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /programs/1 or /programs/1.json
  def destroy
    @program.destroy

    respond_to do |format|
      format.html { redirect_to programs_url, notice: "Program was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_program
      @program = Program.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def program_params
      params.require(:program).permit(:name, :description, :banner_image, :support_contact)
    end
end
