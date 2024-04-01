class ProgramsController < ApplicationController
  before_action :set_program, only: %i[ show edit update destroy]

  # GET /programs or /programs.json
  def index
    @programs = Program.all.order(created_at: :asc)
  end

  # GET /programs/1 or /programs/1.json
  def show
    @mentors = @program.participations.where(role: "mentor")
    @mentees = @program.participations.where(role: "mentee")
    @ranking = Ranking.new
    @participation = @program.participations.find_by(user_id: current_user.id, role: "mentee")
    @rankings = 5.times.map { @participation.rankings.build }
    # TODO remove this ranking here once I'm done with nested associations
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
    @program = Program.new(program_params)

    respond_to do |format|
      if @program.save
        format.html { redirect_to program_url(@program), notice: "Program was successfully created." }
        format.json { render :show, status: :created, location: @program }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @program.errors, status: :unprocessable_entity }
      end
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
      params.require(:program).permit(:name, :owner_id, :description, :banner_image, :support_contact)
    end
end
