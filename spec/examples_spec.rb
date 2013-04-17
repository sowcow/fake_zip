describe FakeZip do
  extend MyTemp.new(:temp, 'tmp/testing.zip')

  describe '.new' do
    it 'takes file name and yaml string' do
      File.write temp, 123
    end
  end
end