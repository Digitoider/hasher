# frozen_string_literal: true

RSpec.describe Hasher do
  subject { Hasher }

  describe 'to_hash' do
    it 'returns correct hash'
  end

  describe '#method_missing' do
    context 'when one link is specified in chain' do
      it 'assigning' do
        h = subject.new
        h.lets = 5
        expect(h.lets!).to eq(5)
      end
    end

    context 'when many links are specified in chain' do
      it 'assigning' do
        h = subject.new
        h.lets.rock = 5
        expect(h.lets.rock!).to eq(5)
      end
    end

    context 'when links was not specified' do
      it 'returns nil' do
        h = subject.new
        expect(h.lets!).to eq(nil)
        expect(h.lets.rock!).to eq(nil)
        h.lets.rock = 5
        expect(h.lets.rock.baby!).to eq(nil)
      end
    end

    context 'when middle link is requested by exclamation' do
      it 'returns Hasher' do
        h = subject.new
        h.lets.rock = 'Ohh yeah, baby!'
        expect(h.lets).to be_an_instance_of(subject)
      end
    end
  end
end
