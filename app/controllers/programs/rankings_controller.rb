class Programs::RankingsController < ApplicationController
  before_action :set_program, only: %i[update destroy]
	before_action :set_participation
	
	def create
		@rankings = 5.times.map { @participation.rankings.build }
		@mentor_options = mentor_options(@program)
  end

  def update
    if @participation.rankings.update(rankings_params)
      redirect_to @participation.program, notice: 'Rankings updated successfully.'
    else
      render :show
    end
  end

	private
	def set_program
		@program = Program.find(params[:program_id])
	end

	def set_participation
		@participation = @program.participations.find_by(user_id: current_user.id, role: "mentee")
	end

  def rankings_params
    params.require(:rankings).map { |rp| rp.permit(:mentor_id, :rank) }
  end
end