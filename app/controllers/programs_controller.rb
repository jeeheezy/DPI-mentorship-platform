class ProgramsController < ApplicationController
  before_action :set_program, only: %i[ show edit update destroy create_rankings update_rankings]

  # GET /programs or /programs.json
  def index
    @programs = Program.all.order(created_at: :asc)
  end

  # GET /programs/1 or /programs/1.json
  def show
    @mentors = @program.participations.where(role: "mentor")
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

  def create_rankings
    @participation = Participation.find_by(program_id: @program.id, user_id: current_user.id, role: 'mentee')
    @rankings = @participation.rankings.new()
  end

  def update_rankings
    @participation = Participation.find_by(program_id: @program.id, user_id: current_user.id, role: 'mentee')
    if @participation.rankings.update(rankings_params)
      redirect_to @participation.program, notice: 'Rankings updated successfully.'
    else
      render :show
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

    def rankings_params
      params.require(:participation).permit(rankings_attributes: [:id, :mentor_id, :rank, :_destroy])
    end
end
