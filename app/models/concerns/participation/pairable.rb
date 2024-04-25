module Participation::Pairable
  extend ActiveSupport::Concern

  included do
    attr_accessor :mentor_pairing_availability
    # TODO: add :update
    validate :valid_mentor_pairing_availability, on: [:create, :update]
    after_create :adjust_mentor_pairings
    after_update :adjust_mentor_pairings
    after_update :pairings_after_changing_roles
    before_destroy :replace_with_empty_pairing, prepend: true
  end

  private
  
  def valid_mentor_pairing_availability
    return unless mentor?
    
    availability = mentor_pairing_availability.to_i
    if availability < 1 || availability > 3
      errors.add(:mentor_pairing_availability, "must be a minimum of 1 and a maximum of 3")
    end

    # if you're already paired with mentees, you can't have less spots than the number of mentees you've paired with
    current_pairings = self.pairings_as_mentors
    formed_pairings = current_pairings.where.not(mentee_id: nil)
    if formed_pairings.count > availability
      errors.add(:mentor_pairing_availability, "cannot be lower than the number of mentees you have already taken on. Contact support if a mentee pairing needs to be removed.")
    end
  end
  
  def adjust_mentor_pairings
    return unless mentor?

    availability = mentor_pairing_availability.to_i
    current_pairings = self.pairings_as_mentors
    if current_pairings.count >= availability
      unformed_pairings = current_pairings.where(mentee_id: nil)
      records_to_destroy = unformed_pairings.limit(current_pairings.count - availability)
      records_to_destroy.each do |record|
      # doing loop for destroy! instead of destroy_all since I'm not sure how exceptions and rollback handled with destroy_all
        record.destroy!
      end
    else
      (availability - current_pairings.count).times do
        Pairing.create!(mentor_id: self.id)
      end
    end
  end

  def pairings_after_changing_roles
    # if you are not a mentor, you should not be in a pairing as a mentor
    unless self.role == "mentor"
      self.pairings_as_mentors.each do |pairing|
        pairing.destroy!
      end
    end

    # if you are not a mentee, you should not have a pairing as a mentee
    unless self.role == "mentee"
      current_pairing = Pairing.find_by(mentee_id: self)
      unless current_pairing.blank?
        new_pairing = Pairing.create(mentor_id: current_pairing.mentor_id)
        current_pairing.destroy!
      end
    end
  end
  
  # If mentee is paired with mentor and that mentee's participation is later destroyed,
  # the pairing record is also destroyed because of dependent_destroy, leaving the mentor with one less pairing than their availability.
  # The following method creates a new pairing with empty mentee_id to replace the destroyed pairing record
  def replace_with_empty_pairing
    if self.role == "mentee"
      current_pairing = Pairing.find_by(mentee_id: self)
      unless current_pairing.blank?
        new_pairing = Pairing.create(mentor_id: current_pairing.mentor_id)
      end
    end
  end

end
