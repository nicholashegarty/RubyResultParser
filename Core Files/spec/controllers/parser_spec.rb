require 'rails_helper'

RSpec.describe ParserController, type: :controller do
end

RSpec.describe Result do
  describe '.parse?' do
    context 'with valid file' do
      let(:file_path) { Rails.root.join('public', 'test.txt') }

      it 'parses the file and returns results' do
        Result.parse?(file_path)
        results = Result.results
        expect(results).to be_a(Hash)
        expect(results.keys).to_not be_empty
      end
    end

    context 'with missing file' do
      it 'returns false' do
        results = Result.parse?('non_existent_file.txt')
        expect(results).to eq(false)
      end
    end
  end

  describe '#assess_type?' do
    it 'correctly assesses the type' do
      result = Result.new('C100', '10.5', ['comment'])
      expect(result.assess_type?).to be(true)
      expect(result.value).to eq(10.5)
      expect(result.format).to eq('float')
    end

    it 'handles unrecognized codes' do
      result = Result.new('X999', '10.5', ['comment'])
      expect(result.assess_type?).to be(false)
    end
  end

  describe '#parse_comments' do
    it 'combines comments into a formatted string' do
      comments_arr = ['NTE', "1", 'comment1', 'NTE', "1", 'comment2']
      Result.clear
      result = Result.new('C100', '10.5', comments_arr)
      expect(Result.results[0][3]).to eq("comment1\ncomment2")
    end
  end
end
