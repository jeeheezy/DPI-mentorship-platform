module MentorOptionsHelper
	def mentor_options(program)
		mentors = program.participations.where(role: "mentor")
		mentors.map { |mentor| [mentor.user.username, mentor.id] }
	end

	def mentee_options(program)
		mentees = program.participations.where(role: "mentee")
		mentees.map { |mentee| [mentee.user.username, mentee.id] }
	end
end