# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ActiveSet do
  before(:all) do
    @thing_1 = FactoryBot.create(:thing, one: FactoryBot.create(:one))
    @thing_2 = FactoryBot.create(:thing, one: FactoryBot.create(:one))
    @active_set = ActiveSet.new(Thing.all)
  end
  after(:all) { Thing.delete_all }

  describe 'enumerable filters that return no results' do
    let(:result) { @active_set.filter(instructions) }
    let(:instructions) do
      {
        'computed_string' => 'wakka'
      }
    end

    it { expect(result).to be_empty }
  end
end
