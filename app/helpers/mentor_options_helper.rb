module MentorOptionsHelper
	def mentor_options(program)
		mentors = program.participations.where(role: "mentor")
		mentors.map { |mentor| [mentor.user.username, mentor.user.id] }
	end
end