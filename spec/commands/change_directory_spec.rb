#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

require 'tmpdir'

describe ChangeDirectory do
  let!(:original) { Dir.pwd }

  before do
    $stdout = StringIO.new
    $stderr = StringIO.new
  end

  after do
    Dir.chdir(original)
    $stdout = STDOUT
    $stderr = STDERR
  end

  subject { ChangeDirectory.new(path) }

  context 'when given a valid path' do
    let(:path) { File.realdirpath(Dir.tmpdir) }

    its(:directory) { should eq(path) }

    context 'and executed' do
      before { subject.execute }

      specify { expect(Dir.pwd).to eq(path) }
    end
  end

  context 'when given an invalid path' do
    let(:path) { '/invalid-path' }

    its(:directory) { should eq(path) }

    context 'and executed' do
      before { subject.execute }

      specify { expect(Dir.pwd).to eq(original) }
      specify { expect($stderr.string).to match(/No such directory/) }
    end
  end
end
