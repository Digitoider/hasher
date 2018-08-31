# frozen_string_literal: true

RSpec.describe Kernel::Serializers::Hasherizer do
  subject { Kernel::Serializers::Hasherizer }

  describe '.to_hash' do
    context 'when passed parameter is not `Kernel::Tree` instance' do
      it 'returns passed parameter' do
        expect(subject.to_hash(5)).to eq(5)
        expect(subject.to_hash('lala')).to eq('lala')
        expect(subject.to_hash(true)).to eq(true)
        expect(subject.to_hash(false)).to eq(false)
      end
    end

    context 'when passed parameter is `Kernel::Tree` instance' do
      it 'returns proper hash' do
        h = Hasher.new
        h.lets.rock.baby = 5
        h.lets.rock.bro  = 'some_string'
        h.lets.rock.with.those.guys = true
        h.this.might.be.interesting = ':0'
        h.this.is.awesome = ':()'
        h.this.is.an.array = %w[hell yeah]
        h.this.is.a.symbol = :I_trully_am_a_symbol

        expected_result = {
          lets: {
            rock: {
              baby: 5,
              bro:  'some_string',
              with: {
                those: {
                  guys: true
                }
              }
            }
          },
          this: {
            might:{
              be: {
                interesting: ':0'
              }
            },
            is: {
              awesome: ':()',
              an: {
                array: %w[hell yeah]
              },
              a: {
                symbol: :I_trully_am_a_symbol
              }
            }
          }
        }
        expect(subject.to_hash(h.__tree)).to eq(expected_result)
      end
    end
  end
end
