class DataParser
  attr_accessor :student_responses, :file_name, :header_map

  def initialize(file_name, header_map)
    @file_name = file_name
    @header_map = header_map
    @student_responses = process_data(file_name, header_map)
  end

  def self.call(file_name, header_map)
    new(file_name, header_map)
  end

  private

  def process_data(file_name, header_map)
   sanitized_students = sanitize_values(
      SmarterCSV.process(file_name, key_mapping: header_map)
    )

   build_student_objects(sanitized_students)

  end

  def build_student_objects(data)
    data.map do |student_data|
      Student.new(**student_data)
    end
  end

  def sanitize_values(data)
    data.each do |student|
      student.each do |key, val|
        student[key] =
          if val.to_s.include? 'NOT'
            false
          elsif val.to_s.include? 'ideal'
            true
          elsif val.to_s.include? 'can'
            :maybe
          else
            val
          end
      end
    end
  end
end

