#
# Copyright (c) 2014 by Lifted Studios. All Rights Reserved.
#

describe ExitShell do
  def exit_status(command)
    begin
      command.execute
    rescue SystemExit => e
      return e.status
    end

    raise 'Expected to raise SystemExit but did not raise an error.'
  end

  def success?(command)
    begin
      command.execute
    rescue SystemExit => e
      return e.success?
    end

    raise 'Expected to raise SystemExit but did not raise an error.'
  end

  context 'when given no value' do
    subject(:command) { ExitShell.new }

    specify { expect { command.execute }.to raise_error(SystemExit) }
    specify { expect(exit_status(command)).to eq(0) }
    specify { expect(success?(command)).to be_true }
  end

  context 'when given true' do
    subject(:command) { ExitShell.new(true) }

    its(:status) { should be_true }
    specify { expect { command.execute }.to raise_error(SystemExit) }
    specify { expect(exit_status(command)).to eq(0) }
    specify { expect(success?(command)).to be_true }
  end

  context 'when given false' do
    subject(:command) { ExitShell.new(false) }

    its(:status) { should be_false }
    specify { expect { command.execute }.to raise_error(SystemExit) }
    specify { expect(exit_status(command)).to eq(1) }
    specify { expect(success?(command)).to be_false }
  end

  context 'when given a non-zero numeric value' do
    subject(:command) { ExitShell.new(5) }

    its(:status) { should eq(5) }
    specify { expect { command.execute }.to raise_error(SystemExit) }
    specify { expect(exit_status(command)).to eq(5) }
    specify { expect(success?(command)).to be_false }
  end

  context 'when given zero as the status' do
    subject(:command) { ExitShell.new(0) }

    its(:status) { should be_true }
    specify { expect { command.execute }.to raise_error(SystemExit) }
    specify { expect(exit_status(command)).to eq(0) }
    specify { expect(success?(command)).to be_true }
  end
end
