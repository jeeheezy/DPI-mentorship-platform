class Programs::ParticipationsController < ApplicationController
  before_action :set_program, only: %i[index]
	
  def index
    @participations = @program.participations.includes([:user])
		# to use program_admin? method in policy, require a participation record to derive program, then determine participation record of current user from that program
		# for index, can use any participation record to derive program id so we'll just choose the first in our list of participations
		authorize @participations.first 
  end


	private
	def set_program
		@program = Program.find(params[:program_id])
	end
end

