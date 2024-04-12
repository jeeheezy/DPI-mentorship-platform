class ParticipationsController < ApplicationController
  before_action :set_participation, only: %i[ show edit update destroy ]
  before_action { authorize(@participation||Participation) }

  # GET /participations or /participations.json
  def index
    @participations = Participation.all
  end

  # GET /participations/1 or /participations/1.json
  def show
  end

  # GET /participations/new
  def new
    @participation = Participation.new
    # TODO find way to change this so program_id can't be so easily changed
    @participation.program_id = params[:program_id]
  end

  # GET /participations/1/edit
  def edit
  end

  # POST /participations or /participations.json
  def create
    Participation.transaction do 
      @participation = Participation.new(participation_params.except(:pairings))
      @participation.user_id = current_user.id
      if participation_params[:role] == "admin"
        program = participation_params[:program_id]
        unless Participation.find_by(program_id: program, user_id:current_user.id).admin?
          raise ArgumentError, "You cannot set an admin if you are not an admin"
        end
      end
      respond_to do |format|
        if @participation.save!
          if @participation.mentor?
            availability = participation_params[:pairings].to_i
            if availability < 1 || availability > 3
              raise ArgumentError, "You must take on at least 1 mentee and can take a max of 3 mentees"
            else 
              availability.times do
                Pairing.create!(mentor_id: @participation.id)
              end
            end
          end  
          format.html { redirect_to program_url(@participation.program), notice: "You have successfully joined this program." }
          format.json { render :show, status: :created, location: @participation }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @participation.errors, status: :unprocessable_entity }
        end
      end
    end
    rescue ArgumentError => e
      respond_to do |format|
        format.html { redirect_to new_participation_url(program_id: @participation.program_id), alert: e.message }
        format.json { render json: { error: e.message }, status: :unprocessable_entity }
      end
    rescue ActiveRecord::RecordInvalid => e
      respond_to do |format|
        format.html { redirect_to new_participation_url(program_id: @participation.program_id), status: :unprocessable_entity, alert: e.message }
        # TODO check what's being rendered in json and see how I should pass in error message
        format.json { render json: e.message, status: :unprocessable_entity }
      end
  end

  # PATCH/PUT /participations/1 or /participations/1.json
  # TODO determine how to delete pairings if number they can take on changes, be it unpaired or paired pairings
  # determine number of current pairings that was stated by user to be shown on field
  def update
    Participation.transaction do
      if participation_params[:role] == "admin"
        program = participation_params[:program_id]
        unless Participation.find_by(program_id: program, user_id:current_user.id).admin?
          raise ArgumentError, "You cannot set an admin if you are not an admin"
        end
      end
      if participation_params[:role]!= "mentor"
        # is it better to loop through and do destroy! ?
        @participation.pairings_as_mentors.destroy_all
      else
        availability = participation_params[:pairings].to_i
        if availability < 1 || availability > 3
          raise ArgumentError, "You must take on at least 1 mentee and can take a max of 3 mentees"
        else 
          current_pairings = @participation.pairings_as_mentors
          if current_pairings.count >= availability
            formed_pairings = current_pairings.where.not(mentee_id: nil)
            if formed_pairings.count > availability
              raise ArgumentError, "You cannot lower the number of mentees to less than the current number of mentees you have already taken on. Please contact the admin if a mentee pairing needs to be removed."
            else
              unformed_pairings = current_pairings.where(mentee_id: nil)
              records_to_destroy = unformed_pairings.limit(current_pairings.count - availability)
              records_to_destroy.destroy_all 
            end
          else
            (availability - @participation.pairings_as_mentors.count).times do
              Pairing.create!(mentor_id: @participation.id)
            end
          end
        end
      end
      respond_to do |format|
        if @participation.update!(participation_params.except(:pairings))
          format.html { redirect_to program_rankings_index_url(@participation.program), notice: "Participation was successfully updated." }
          format.json { render :show, status: :ok, location: @participation }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @participation.errors, status: :unprocessable_entity }
        end
      end
    end
  rescue ArgumentError => e
    respond_to do |format|
      format.html { redirect_to edit_participation_url(program_id: @participation.program_id), alert: e.message }
      format.json { render json: { error: e.message }, status: :unprocessable_entity }
    end
  rescue ActiveRecord::RecordInvalid => e
    respond_to do |format|
      format.html { redirect_to edit_participation_url(program_id: @participation.program_id), status: :unprocessable_entity, alert: e.message }
      # TODO check what's being rendered in json and see how I should pass in error message
      format.json { render json: e.message, status: :unprocessable_entity }
    end
  end
 
  # DELETE /participations/1 or /participations/1.json
  def destroy
    @program = @participation.program
    @participation.destroy

    respond_to do |format|
      format.html { redirect_to program_rankings_index_url(@program), notice: "Participation was successfully destroyed." }
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
      params.require(:participation).permit(:program_id, :role, :pairings)
    end

end
