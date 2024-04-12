class Programs::RankingsController < ApplicationController
  before_action :set_program, only: %i[index create update]
	before_action :set_current_user_participation, only: %i[create update]
	
  def index
    @rankings = @program.mentee_rankings
    @participations = @program.participations
  end

	def create
    mentor_id_array = rankings_params[:mentor_id]
    non_empty_array = mentor_id_array.compact.reject(&:blank?)
    Ranking.transaction do 
      non_empty_array.each_with_index do |mentor_id, index|
        raise ArgumentError, "The user you are trying to rank is not a mentor" unless Participation.find(mentor_id).mentor?
        rank = index + 1
        Ranking.create!(mentee_id: @current_user_participation.id, mentor_id: mentor_id, rank: rank)
      end
      respond_to do |format|
        format.html { redirect_to program_url(@program), notice: "Ranking was successfully created." }
        format.json { render :show, status: :created, location: @ranking }
      end
    end
    rescue ArgumentError => e
      respond_to do |format|
        format.html { redirect_to program_url(@program), alert: e.message }
        format.json { render json: { error: e.message }, status: :unprocessable_entity }
      end
    rescue ActiveRecord::RecordInvalid => e
      respond_to do |format|
        format.html { redirect_to program_url(@program), alert: e.message }
        format.json { render json: e.message, status: :unprocessable_entity }
      end
      # 8, 7, 6
      # 6, 2, 7
      # Frank, Bob, Grace
      # 4, 6, 8, 33
      # 8, 7
      # Heidi, Grace, Frank, TEST
  end

  def update
    # TODO remember to deal with deletion of all ranks if flattened array is 0
    mentor_id_array = rankings_params[:mentor_id]
    non_empty_array = mentor_id_array.compact.reject(&:blank?)
    current_rankings = @current_user_participation.rankings
    # do I need to check that the passed in values are mentor values?
    # might be more effective if I keep transaction to update existing ranked records, but nested transactions have their own issues
    Ranking.transaction do
      current_rankings.destroy_all
      non_empty_array.each_with_index do |mentor_id, index|
        raise ArgumentError, "The user you are trying to rank is not a mentor" unless Participation.find(mentor_id).mentor?
        rank = index + 1
        Ranking.create!(mentee_id: @current_user_participation.id, mentor_id: mentor_id, rank: rank)
      end
      respond_to do |format|
        format.html { redirect_to program_url(@program), notice: "Ranking was successfully created." }
        format.json { render :show, status: :created, location: @ranking }
      end
    end
    rescue ArgumentError => e
      respond_to do |format|
        format.html { redirect_to program_url(@program), alert: e.message }
        format.json { render json: { error: e.message }, status: :unprocessable_entity }
      end
    rescue ActiveRecord::RecordInvalid => e
      respond_to do |format|
        format.html { redirect_to program_url(@program), alert: e.message }
        format.json { render json: e.message, status: :unprocessable_entity }
      end
  end

	private
	def set_program
		@program = Program.find(params[:program_id])
	end

	def set_current_user_participation
		@current_user_participation = @program.participations.find_by(user_id: current_user.id, role: "mentee")
	end

  def rankings_params
    params.require(:ranking).permit(mentor_id:[])
    # params.require(:ranking).map { |rp| rp.permit(:mentor_id, :rank) }
  end
end

#<ActionController::Parameters {"authenticity_token"=>"1MtXFuwt8ZwKaUWHaBQsPlT1awDD5Qsp_sWu5L6wREekzui5dFfALpH4G11EAxy5z_QzePuFxAXkkonT6_RpbQ", 
# "ranking"=>{"0"=>{"mentor_id"=>""}, "1"=>{"mentor_id"=>""}, "2"=>{"mentor_id"=>""}, "3"=>{"mentor_id"=>""}, "4"=>{"mentor_id"=>""}}, 
# "commit"=>"Submit Rankings", "controller"=>"programs/rankings", "action"=>"create", "program_id"=>"1"} permitted: false>

# ranking = [id, id, id, id]
# ["9", "7", "", "", ""]

# array
# for array index:
# get ranking:
# if ranking position and array index == 
    # check mentor id
        # if mentor_id different: change it
    #
