class Programs::ParticipationsController < ApplicationController
  before_action :set_program, only: %i[index]
	
  def index
    @rankings = @program.mentee_rankings
    @participations = @program.participations
  end


	private
	def set_program
		@program = Program.find(params[:program_id])
	end

	def set_current_user_participation
		@current_user_participation = @program.participations.find_by(user_id: current_user.id, role: "mentee")
	end
end

