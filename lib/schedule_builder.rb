# This really just allocates students to time slots
class ScheduleBuilder
  attr_reader :data, :time_slots

  def initialize(data)
    @data = data
    @time_slots = build_tf_slots
  end

  def call
    data.each do |student|
      student.timeslots.select { |_k, v| v }.each do |time_slot, availability|
        begin
          slot = find_slot(time_slot.to_s, student)
          raise NoAvailableSlot if slot.nil?
          slot.add_student(student, availability)
        rescue MaxCapacity, NoAvailableSlot, StudentAlreadyAllocated
          add_time_slot(time_slot)
          retry
        end
      end
    end

    mark_inactive_time_slots

    time_slots.select(&:time_slot_active)
  end

  private

  def mark_inactive_time_slots
    time_slots.each do |slot|
      if slot.below_min_student_capacity?
        slot.time_slot_active = false
      end
    end
  end

  def add_time_slot(time_slot)
    time_slots << TimeSlot.new(time_slot.to_s)
  end

  def find_slot(time_slot, student)
    time_slots.find do |slot|
      !slot.at_max_student_capacity? && slot.name == time_slot.to_s &&  slot.time_slot_active && !slot.definite_students.include?(student)

    end
  end

  def build_tf_slots
    HEADER_MAP.values.map do |val|
      next if val == :name || val == :email || val.nil?

      TimeSlot.new(val)
    end.compact
  end
end

class NoAvailableSlot < StandardError
end
