# nice!
module MentorOptionsHelper
	def mentor_options(program)
		mentors = program.participations.where(role: "mentor")
		mentors.map { |mentor| [mentor.user.first_name, mentor.id] }
	end

	def mentee_options(program)
		mentees = program.participations.where(role: "mentee").includes([:user])
		mentees.map { |mentee| [mentee.user.first_name, mentee.id] }
	end
end
