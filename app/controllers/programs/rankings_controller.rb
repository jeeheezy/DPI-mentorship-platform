class Programs::RankingsController < ApplicationController
  before_action :set_program, only: %i[create update destroy]
	before_action :set_participation
	
	def create
    rankings_params
    debugger
		@rankings = 5.times.map { @participation.rankings.build }
    @ranking = Ranking.new()
  end

  def update
    # currently ranks are not explicitly taken from params, but indexed
    # do I need to permit rank?
    debugger
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
    params.require(:ranking).permit(mentor_id:[])
    # params.require(:ranking).map { |rp| rp.permit(:mentor_id, :rank) }
  end
end

#<ActionController::Parameters {"authenticity_token"=>"1MtXFuwt8ZwKaUWHaBQsPlT1awDD5Qsp_sWu5L6wREekzui5dFfALpH4G11EAxy5z_QzePuFxAXkkonT6_RpbQ", 
# "ranking"=>{"0"=>{"mentor_id"=>""}, "1"=>{"mentor_id"=>""}, "2"=>{"mentor_id"=>""}, "3"=>{"mentor_id"=>""}, "4"=>{"mentor_id"=>""}}, 
# "commit"=>"Submit Rankings", "controller"=>"programs/rankings", "action"=>"create", "program_id"=>"1"} permitted: false>

# ranking = [id, id, id, id]


# array
# for array index:
# get ranking:
# if ranking position and array index == 
    # check mentor id
        # if mentor_id different: change it
    #
