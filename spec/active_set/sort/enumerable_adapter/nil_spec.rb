# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveSet::SortProcessor::EnumerableAdapter do
  include_context 'for enumerable sets'

  let(:adapter) { described_class.new(keypath, value) }

  describe '#process with String type attribute value' do
    subject { adapter.process(enumerable_set) }

    context 'on the base object' do
      before(:each) do
        foo.nil = nil
        bar.nil = '___'
      end

      context 'when direction is ASC' do
        context 'with default case-sensitive sort' do
          let(:keypath) { [:nil] }
          let(:value) { :asc }

          it { expect(subject.map(&:id)).to eq [foo.id, bar.id] }
        end

        context 'with case-INsensitive sort' do
          let(:keypath) { ['nil(i)'] }
          let(:value) { 'asc' }

          it { expect(subject.map(&:id)).to eq [foo.id, bar.id] }
        end
      end

      context 'when direction is DESC' do
        context 'with default case-sensitive sort' do
          let(:keypath) { [:nil] }
          let(:value) { :desc }

          it { expect(subject.map(&:id)).to eq [bar.id, foo.id] }
        end

        context 'with case-INsensitive sort' do
          let(:keypath) { ['nil(i)'] }
          let(:value) { 'desc' }

          it { expect(subject.map(&:id)).to eq [bar.id, foo.id] }
        end
      end
    end

    context 'on an associated object' do
      before(:each) do
        foo.assoc.nil = nil
        bar.assoc.nil = '___'
      end

      context 'when direction is ASC' do
        context 'with default case-sensitive sort' do
          let(:keypath) { %w[assoc nil] }
          let(:value) { :asc }

          it { expect(subject.map(&:id)).to eq [foo.id, bar.id] }
        end

        context 'with case-INsensitive sort' do
          let(:keypath) { %w[assoc nil(i)] }
          let(:value) { 'asc' }

          it { expect(subject.map(&:id)).to eq [foo.id, bar.id] }
        end
      end

      context 'when direction is DESC' do
        context 'with default case-sensitive sort' do
          let(:keypath) { %w[assoc nil] }
          let(:value) { :desc }

          it { expect(subject.map(&:id)).to eq [bar.id, foo.id] }
        end

        context 'with case-INsensitive sort' do
          let(:keypath) { %w[assoc nil(i)] }
          let(:value) { 'desc' }

          it { expect(subject.map(&:id)).to eq [bar.id, foo.id] }
        end
      end
    end
  end
end
