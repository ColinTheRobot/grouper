require 'pry'
require 'smarter_csv'
require 'rubygems'
require 'active_support'
require "active_support/all"
require_relative 'lib/student'
require_relative 'lib/schedule_builder'
require_relative 'lib/data_parser'
require_relative 'lib/time_slot'

HEADER_MAP = {
  timestamp: nil,
  'what_is_your_name,_as_it_appears_on_my.harvard?': :name,
  'what_is_your_email_address,_as_it_appears_on_my.harvard?': :email,
  'which_of_these_sessions_work_for_you?_please_check_all_that_apply._[7:30_8:45am]': '[7:30_8:45am]',
  'which_of_these_sessions_work_for_you?_please_check_all_that_apply._[9:00_10:15am]': '[9:00_10:15am]',
  'which_of_these_sessions_work_for_you?_please_check_all_that_apply._[10:30_11:45am]': '[10:30_11:45am]',
  'which_of_these_sessions_work_for_you?_please_check_all_that_apply._[12:00_1:15pm]': '[12:00_1:15pm]',
  'which_of_these_sessions_work_for_you?_please_check_all_that_apply._[1:30_2:45pm]': '[1:30_2:45pm]',
  'which_of_these_sessions_work_for_you?_please_check_all_that_apply._[3:00_4:15pm]': '[3:00_4:15pm]',
  'which_of_these_sessions_work_for_you?_please_check_all_that_apply._[4:30_5:45pm]': '[4:30_5:45pm]',
  'which_of_these_sessions_work_for_you?_please_check_all_that_apply._[6:00_7:15pm]': '[6:00_7:15pm]',
  'which_of_these_sessions_work_for_you?_please_check_all_that_apply._[7:30_8:45pm]': '[7:30_8:45pm]',
  'which_of_these_sessions_work_for_you?_please_check_all_that_apply._[9:00_10:15pm]': '[9:00_10:15pm]'
}

schedule = ScheduleBuilder.new(
  DataParser.call('real_data.csv', HEADER_MAP).student_responses
).call

schedule = schedule.map do |slot|
  # next unless slot.time_slot_active
  {
    slot.name => {
      definite_students: slot.definite_students.count,
      time_slot_active: slot.time_slot_active
    }
  }
end

puts schedule.count
puts schedule

