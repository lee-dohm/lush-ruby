#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

describe ExportVariable do
  let(:env) { {} }

  before { redirect_standard_streams }
  after { reset_standard_streams }

  context 'when given a key and value' do
    subject(:command) { ExportVariable.new('KEY', 'value') }

    before do
      command.env = env
      command.execute
    end

    specify { expect(env['KEY']).to eq('value') }
  end

  context 'when given a key and no value' do
    subject(:command) { ExportVariable.new('KEY', '') }

    before do
      command.env = env
      command.execute
    end

    specify { expect(env['KEY']).to be_nil }
  end

  context 'when given the -p parameter' do
    subject(:command) { ExportVariable.new('-p') }

    before do
      command.env = { 'foo' => 'one', 'bar' => 'two', 'baz' => 'three' }
      command.execute
    end

    specify do
      expect($stdout.string).to eq("export bar=two\nexport baz=three\nexport foo=one\n")
    end
  end

  context 'when given no arguments' do
    subject(:command) { ExportVariable.new }

    before do
      command.env = { 'foo' => 'one', 'bar' => 'two', 'baz' => 'three' }
      command.execute
    end

    specify do
      expect($stdout.string).to eq("bar=two\nbaz=three\nfoo=one\n")
    end
  end
end
