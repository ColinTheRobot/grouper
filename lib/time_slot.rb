class TimeSlot
  attr_accessor :name, :time_of_data, :definite_students, :maybe_students, :overflow, :time_slot_active

  MAX_NUMBER_OF_STUDENTS = 15
  MIN_NUMBER_OF_STUDENTS = 12

  def initialize(name)
    @name = name
    @time_of_day = name.include?('pm') ? 'pm' : 'am'
    @definite_students = []
    @maybe_students = []
    @time_slot_active = true
  end

  def add_student(student, availability)
    raise MaxCapacity if at_max_student_capacity?
    # raise StudentAlreadyAllocated if student.allocated?

    # tell studen object they've been added.
    # raise if student has already been added to a group

    if availability == :maybe
      @maybe_students << student
    else
      @definite_students << student
      student.allocated = true
    end
  end

  def toggle_time_slot_active
    time_slot_active = !time_slot_active
  end

  def at_max_student_capacity?
    definite_students.count == MAX_NUMBER_OF_STUDENTS ? true : false
  end

  def below_min_student_capacity?
    definite_students.count <= MIN_NUMBER_OF_STUDENTS ? true : false
  end

end

class MaxCapacity < StandardError
end

class StudentAlreadyAllocated < StandardError
end
