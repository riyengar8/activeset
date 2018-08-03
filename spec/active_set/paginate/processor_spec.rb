# frozen_string_literal: true

require 'spec_helper'
require 'ostruct'

RSpec.describe ActiveSet::Processor::Paginate do
  let(:processor) { described_class.new(set, paginate_structure) }

  context 'when set is Enumerable and instructions hash has Symbol keys' do
    let(:foo) { OpenStruct.new(key: 'foo', association: OpenStruct.new(key: 'oof')) }
    let(:bar) { OpenStruct.new(key: 'bar', association: OpenStruct.new(key: 'rab')) }
    let(:baz) { OpenStruct.new(key: 'baz', association: OpenStruct.new(key: 'zab')) }
    let(:set) { [foo, bar, baz] }

    describe '#process' do
      subject { processor.process }

      context 'when page size is smaller than set size' do
        context 'when set is divisible by page size' do
          let(:size) { 1 }

          context 'when on first page' do
            let(:paginate_structure) { { page: 1, size: size } }

            it { should eq [foo] }
          end

          context 'when on last page' do
            let(:paginate_structure) { { page: 3, size: size } }

            it { should eq [baz] }
          end

          context 'when on irrational page' do
            let(:paginate_structure) { { page: 10, size: size } }

            it { should eq [] }
          end
        end

        context 'when set is not divisible by page size' do
          let(:size) { 2 }

          context 'when on first page' do
            let(:paginate_structure) { { page: 1, size: size } }

            it { should eq [foo, bar] }
          end

          context 'when on last page' do
            let(:paginate_structure) { { page: 2, size: size } }

            it { should eq [baz] }
          end

          context 'when on irrational page' do
            let(:paginate_structure) { { page: 10, size: size } }

            it { should eq [] }
          end
        end
      end

      context 'when page size is equal to set size' do
        let(:size) { set.count }

        context 'when on only page' do
          let(:paginate_structure) { { page: 1, size: size } }

          it { should eq [foo, bar, baz] }
        end

        context 'when on irrational page' do
          let(:paginate_structure) { { page: 10, size: size } }

          it { should eq [] }
        end
      end

      context 'when page size is greater than set size' do
        let(:size) { set.count + 1 }

        context 'when on only page' do
          let(:paginate_structure) { { page: 1, size: size } }

          it { should eq [foo, bar, baz] }
        end

        context 'when on irrational page' do
          let(:paginate_structure) { { page: 10, size: size } }

          it { should eq [] }
        end
      end
    end
  end

  context 'when set is ActiveRecord::Relation and instructions hash has String keys' do
    include_context 'for active record sets'
    let!(:baz) { Foo.create(assoc: Assoc.create) }

    let(:set) { Foo.all }

    describe '#process' do
      subject { processor.process }

      context 'when page size is smaller than set size' do
        context 'when set is divisible by page size' do
          let(:size) { 1 }

          context 'when on first page' do
            let(:paginate_structure) { { 'page' => 1, 'size' => size } }

            it { should eq [foo] }
          end

          context 'when on last page' do
            let(:paginate_structure) { { 'page' => 3, 'size' => size } }

            it { should eq [baz] }
          end

          context 'when on irrational page' do
            let(:paginate_structure) { { 'page' => 10, 'size' => size } }

            it { should eq [] }
          end
        end

        context 'when set is not divisible by page size' do
          let(:size) { 2 }

          context 'when on first page' do
            let(:paginate_structure) { { 'page' => 1, 'size' => size } }

            it { should eq [foo, bar] }
          end

          context 'when on last page' do
            let(:paginate_structure) { { 'page' => 2, 'size' => size } }

            it { should eq [baz] }
          end

          context 'when on irrational page' do
            let(:paginate_structure) { { 'page' => 10, 'size' => size } }

            it { should eq [] }
          end
        end
      end

      context 'when page size is equal to set size' do
        let(:size) { set.count }

        context 'when on only page' do
          let(:paginate_structure) { { 'page' => 1, 'size' => size } }

          it { should eq [foo, bar, baz] }
        end

        context 'when on irrational page' do
          let(:paginate_structure) { { 'page' => 10, 'size' => size } }

          it { should eq [] }
        end
      end

      context 'when page size is greater than set size' do
        let(:size) { set.count + 1 }

        context 'when on only page' do
          let(:paginate_structure) { { 'page' => 1, 'size' => size } }

          it { should eq [foo, bar, baz] }
        end

        context 'when on irrational page' do
          let(:paginate_structure) { { 'page' => 10, 'size' => size } }

          it { should eq [] }
        end
      end
    end
  end
end
