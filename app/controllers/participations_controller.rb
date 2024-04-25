class ParticipationsController < ApplicationController
  before_action :set_participation, only: %i[ show edit update destroy ]

  # GET /participations/new
  def new
    @participation = Participation.new
    # Currently program_id can easily be changed before create but will be a non-issue once participation is set to be invite only
    @participation.program_id = params[:program_id]
    authorize @participation
  end

  # GET /participations/1/edit
  def edit
    authorize @participation
  end

  def create
    @participation = current_user.participations.new(participation_params)
    authorize @participation

    respond_to do |format|
      if @participation.save
        format.html { redirect_to program_url(@participation.program), notice: "You have successfully joined this program." }
        format.json { render :show, status: :created, location: @participation }
      else
        # TODO define error somehow and display it to page
        format.html { redirect_to new_participation_url(program_id: @participation.program_id), status: :unprocessable_entity, alert: @participation.errors.full_messages.join(", ") }
        format.json { render json: @participation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /participations/1 or /participations/1.json
  # TODO determine how to delete pairings if number they can take on changes, be it unpaired or paired pairings
  # determine number of current pairings that was stated by user to be shown on field
  def update
    @participation.assign_attributes(participation_params)
    authorize (@participation)

    respond_to do |format|
      if @participation.save
        format.html { redirect_to program_participations_index_url(@participation.program), notice: "Participation was successfully updated." }
        format.json { render :show, status: :created, location: @participation }
      else
        format.html { redirect_to edit_participation_url(program_id: @participation.program_id), status: :unprocessable_entity, alert: @participation.errors.full_messages.join(", ") }
        format.json { render json: @participation.errors, status: :unprocessable_entity }
      end
    end
  end
 
  # DELETE /participations/1 or /participations/1.json
  def destroy
    authorize @participation
    @program = @participation.program
    @participation.destroy

    respond_to do |format|
      format.html { redirect_to program_participations_index_url(@program), notice: "Participation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_participation
      @participation = Participation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def participation_params
      params.require(:participation).permit(:program_id, :role, :mentor_pairing_availability)
    end

end
