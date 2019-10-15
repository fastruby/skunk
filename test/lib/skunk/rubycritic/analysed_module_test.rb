require 'test_helper'

require 'rubycritic/analysers_runner'
require 'skunk/rubycritic/analysed_module'

describe RubyCritic::AnalysedModule do
  let(:paths) { 'lib/skunk/rubycritic' }

  before do
    runner = RubyCritic::AnalysersRunner.new(paths)
    analysed_modules = runner.run
    @analysed_module = analysed_modules.first
  end

  describe '#stink_score' do
    it 'should be zero' do
      @analysed_module.stink_score.must_equal 0
    end
  end
end
