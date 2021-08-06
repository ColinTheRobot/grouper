class Student
  attr_accessor :name, :email, :timeslots, :allocated

  def initialize(**data)
    @name = data.delete(:name)
    @email = data.delete(:email)
    @timeslots = data
    @allocated = false
  end

  def allocated?
    @allocated
  end

  def ==(other)
    other.name == name && other.email == email

    # require 'pry'; binding.pry
    # raise "timeslot data missmatch for student: #{name}" if other.timeslots != timeslots
  end
  alias :eql? :==

end
