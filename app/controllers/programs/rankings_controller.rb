class Programs::RankingsController < ApplicationController
  before_action :set_program, only: %i[create update]
	before_action :set_current_user_participation, only: %i[create update]
  # since there's multiple records being created and destroyed, there's no singular Ranking record to verify and class similarly isn't useful
  # Instead will use @current_user_participation which already has criteria for role = "mentee". 
  # Check returned participation is truthy (i.e. they are mentee) or falsey (i.e. find_by returned nil)
  before_action { authorize(@current_user_participation, policy_class: RankingPolicy) }

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
  end

  def update
    # authorize(@current_user_participation, policy_class: RankingPolicy)
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
  end
end

