# frozen_string_literal: true

class INodeMock
  attr_accessor :key, :value, :nodes

  def initialize(key = nil, value = nil)
    @key = key
    @value = value
    @nodes = []
  end

  def leaf?
    raise NotImplementedError, 'Method `.leaf?` must be implemented.'
  end

  def composite?
    raise NotImplementedError, 'Method `.composite?` must be implemented.'
  end
end

class LeafMock < INodeMock
  def leaf?
    true
  end

  def composite?
    false
  end
end

class CompositeMock < INodeMock
  def leaf?
    false
  end

  def composite?
    true
  end
end

class TreeMock < INodeMock
  def initialize
    @nodes = []
  end

  def add(node)
    nodes << node
  end

  def leaf?
    false
  end

  def composite?
    true
  end
end

RSpec.describe Kernel::TreePrinter do
  let(:subject) {Kernel::TreePrinter}

  describe '#build_result' do
    context 'when tree is empty' do
      it 'succeeds' do
        tree = CompositeMock.new
        tree.key = 'root'

        a = LeafMock.new(:a, 1)

        b = CompositeMock.new(:b)
        b1 = LeafMock.new(:b1, 'hop')
        b2 = CompositeMock.new(:b2)
        b22 = LeafMock.new(:b22, 34)
        b21 = CompositeMock.new(:b21)
        b21.nodes << LeafMock.new(:b221, {hash: 'easy'})
        b21.nodes << LeafMock.new(:b222, 34)
        b2.nodes.push b22, b21
        b3 = LeafMock.new(:b3, 'lalaila')
        b.nodes.push b1, b2, b3
        tree.nodes.push a, b

        result = subject.new.build_result(tree)
        subject.new.print(tree)

        expect(result[0]).to eq('root')
        expect(result[1]).to eq('|--a: 1')
        expect(result[2]).to eq('`--b')
        expect(result[3]).to eq('   |--b1: hop')
        expect(result[4]).to eq('   |--b2')
        expect(result[5]).to eq('   |  |--b22: 34')
        expect(result[6]).to eq('   |  `--b21')
        expect(result[7]).to eq('   |     |--b221: {:hash=>"easy"}')
        expect(result[8]).to eq('   |     `--b222: 34')
        expect(result[9]).to eq('   `--b3: lalaila')
      end
    end
  end
end
