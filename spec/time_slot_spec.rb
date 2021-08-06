require 'time_slot'
require 'student'

RSpec.describe TimeSlot do
  let(:student) do
    Student.new(name: 'a', email: 'a@b.com', '[7:30_8:45am]': true, '[9:00_10:15am]': false,
                '[10:30_11:45am]': false, '[12:00_1:15pm]': true)
  end
  let(:students) do
    [
      Student.new(name: 'a', email: 'a@b.com', '[7:30_8:45am]': true, '[9:00_10:15am]': false,
                  '[10:30_11:45am]': false, '[12:00_1:15pm]': true),
      Student.new(name: 'a', email: 'a@b.com', '[7:30_8:45am]': true, '[9:00_10:15am]': false,
                  '[10:30_11:45am]': false, '[12:00_1:15pm]': true),
      Student.new(name: 'a', email: 'a@b.com', '[7:30_8:45am]': true, '[9:00_10:15am]': false,
                  '[10:30_11:45am]': false, '[12:00_1:15pm]': true),
      Student.new(name: 'a', email: 'a@b.com', '[7:30_8:45am]': true, '[9:00_10:15am]': false,
                  '[10:30_11:45am]': false, '[12:00_1:15pm]': true),
      Student.new(name: 'a', email: 'a@b.com', '[7:30_8:45am]': true, '[9:00_10:15am]': false,
                  '[10:30_11:45am]': false, '[12:00_1:15pm]': true)
    ]
  end
  let(:time_slot) { described_class.new('[10:30_11:45am]') }

  describe '#add_student' do
    it 'adds a student based on answers to timeslots' do
      expect { time_slot.add_student(student, true) }.to change { time_slot.definite_students.count }.by 1
      expect { time_slot.add_student(student, false) }.not_to change { time_slot.definite_students.count }
      expect { time_slot.add_student(student, false) }.not_to change { time_slot.maybe_students.count }
      expect { time_slot.add_student(student, :maybe) }.to change { time_slot.maybe_students.count }.by 1
    end

    it 'toggles the student as allocated when availability is true' do
      expect { time_slot.add_student(student, true) }.to change { student.allocated }.from(false).to(true)
    end

    it 'does not toggle the student as allocated when availability is not true' do
      expect { time_slot.add_student(student, false) }.to_not change { student.allocated }.from(false)
      expect { time_slot.add_student(student, :maybe) }.to_not change { student.allocated }.from(false)
    end

    it 'raises if time slot is at capacity' do
      15.times do
        time_slot.definite_students << 'student'
      end
      expect { time_slot.add_student(student, true) }.to raise_error MaxCapacity
    end
  end

  describe 'toggle_time_slot_active' do
    it 'toggles time_slot' do
      expect { time_slot.toggle_time_slot_active }.to change { time_slot.time_slot_active }
    end
  end

  describe 'at_max_student_capacity?' do
    it 'returns true if at capacity definite students' do
      described_class::MAX_NUMBER_OF_STUDENTS.times do
        time_slot.definite_students << 'student'
      end
      expect(time_slot.at_max_student_capacity?).to eq true
    end
  end

  describe 'below_min_student_capacity?' do
    it 'returns true if there are less than 12 definite students' do
      (described_class::MIN_NUMBER_OF_STUDENTS - 1).times do
        time_slot.definite_students << 'student'
      end

      expect(time_slot.below_min_student_capacity?).to eq true
    end
  end
end
