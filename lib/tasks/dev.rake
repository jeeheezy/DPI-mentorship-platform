unless Rails.env.production?
  namespace :dev do
    desc "Destroy, create, migrate, and seed database"
    task reset: [
      :environment, 
      "db:drop", 
      "db:create", 
      "db:migrate", 
      "db:seed", 
      "dev:sample_data"] do
      puts "done resetting"
    end

    desc "Fill the database tables with some sample data"
    task({ :sample_data => :environment }) do
      p "Creating sample data"

      usernames = ["Alice", "Bob", "Carol", "Dave", "Eve", "Frank", "Grace", "Heidi"]
      usernames.each do |username|
        User.create(
          email: "#{username}@example.com",
          password: "password",
          username: username.capitalize,
          bio: "Hello, I am #{username.capitalize}.",
          pic: "http://robohash.org/#{username.downcase}/?set=set4",
          preferred_timezone: User.preferred_timezones.keys.sample
        )
      end
      p "There are now #{User.count} users"

      admin_alice = User.find_by(username: "Alice")

      programs = ["spring", "summer", "fall", "winter"]
      programs.each do |program|
        Program.create(
          name: "#{program.capitalize} Cohort",
          description: "This is the program for the #{program} cohort.",
          banner_image: "/assets/images/banner_image.png",
          owner_id: admin_alice.id,
          support_contact: admin_alice.email
        )
      end
      p "There are now #{Program.count} programs."

      created_programs = Program.all
      users_except_alice = User.where.not(username: "Alice")
      # can't use offset here because the skipped record would get included when doing randomly order a few lines down

      created_programs.each do |program|
        users = users_except_alice.order("RANDOM()") 
        # using all users except alice who was program creator, added to inside of loop to get randomly ordered user relation for every program
        Participation.create(
          program_id: program.id,
          user_id: admin_alice.id,
          role: "admin"
        )
        users.each do |user|
          if Participation.where(role: "mentee",program_id: program.id).count <= (Participation.where(program_id: program.id).count)/2
            Participation.create(
              program_id: program.id,
              user_id: user.id,
              role: "mentee"
            )
          else
            Participation.create(
              program_id: program.id,
              user_id: user.id,
              role: "mentor"
            )
          end
        end
      end
      p "There are now #{Participation.count} participations."

      # creating rankings and pairings without any algorithm for matching for now
      mentee_participations_for_ranking = Participation.where(role: "mentee")
      mentee_participations_for_ranking.each do |participation|
        mentor_participations = Participation.where(role:"mentor", program_id: participation.program)
        if rand < 0.8
          3.times do |i|
            mentor = mentor_participations.sample
            Ranking.create(
              mentee_participation: participation,
              mentor_participation: mentor,
              rank: i + 1
            )
            mentor_participations = mentor_participations.where.not(id: mentor.id)
          end
        end
      end

      p "There are now #{Ranking.count} rankings."

      # currently allowing any participations from any programs to match to each other, need to make sure I only allow the ones from the same program
      mentor_participations_for_pairing = Participation.where(role: "mentor")
      mentor_participations_for_pairing.each do |participation|
        rand(1..3).times do
          Pairing.create(
            mentor_id: participation.id
          )
        end
      end

      mentee_participations = Participation.where(role: "mentee")
      mentee_participations.each do |participation|
        available_pairings = Pairing.joins("INNER JOIN participations ON participations.id = pairings.mentor_id")
        .where(mentee_id: nil, participations: { program_id: participation.program })
        if rand < 0.5
          staged_pairing = available_pairings.sample
          staged_pairing.update(
            mentee_id: participation.id
          )
        end
      end
      p "There are now #{Pairing.count} pairing slots, of which there are #{Pairing.where.not(mentee_id:nil).count} formed pairs."
    end
  end
end