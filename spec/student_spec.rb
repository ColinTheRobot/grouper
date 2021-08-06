require 'student'

RSpec.describe Student do

  describe '#==' do
    let(:student_1) { Student.new({ name: 'Foo', email: 'foo@bar.com' }) }
    let(:student_2) { Student.new({ name: 'Foo', email: 'foo@bar.com' }) }
    let(:student_3) { Student.new({ name: 'Baz', email: 'bazz@quz.com', other: 'aaa'}) }
    let(:student_4) { Student.new({ name: 'Baz', email: 'bazz@quz.com', other_data: 'zzz' }) }

    it 'compares student objects by name and email' do
      expect(student_1).to eq(student_2)
      expect(student_1).to_not eq(student_3)
    end

    it 'does not compare student objects by other attributes' do
      expect(student_1).to eq(student_2)
      expect(student_1).to_not eq(student_3)
    end
  end
end
