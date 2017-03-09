require 'spec_helper'

RSpec.describe Event, type: :model do

  let! (:event) {
    FactoryGirl.create(:user)
    FactoryGirl.create(:event)
  }

  describe 'Validations' do
    it { should validate_presence_of(:user_id) }
  end

  describe  'Associations' do
    it { should belong_to(:user) }
  end

  describe '#published?' do
    context 'with all attributes present' do
      it 'returns true' do
        expect(event.published?).to be_truthy
      end
    end

    context 'with missing attributes' do
      it 'returns false' do
        event.update(name: "")
        event.reload

        expect(event.published?).to be_falsey
      end
    end
  end

  describe '#subset_attributes_present' do
    it 'validates presence of any attribute' do
      event1 = Event.new
      event1.valid?

      expect(event1.errors[:base]).to include("Event needs at least one field")
    end
  end

  describe '#all_attributes_present?' do
    context 'with all attributes present' do
      it 'returns true' do
        expect(event.send('all_attributes_present?')).to be_truthy
      end
    end

    context 'with any missing attribute' do
      it 'returns false' do
        event.update(name: "")
        event.reload

        expect(event.send('all_attributes_present?')).to be_falsey
      end
    end
  end

  describe '#tag_as_removed' do
    it 'saves :removed attribute as true' do
      expect(event.removed).to be_falsey
      event.tag_as_removed
      expect(event.removed).to be_truthy
    end
  end

  describe '#calculate_dates_and_duration' do
    context 'with start_date and duration' do
      it 'calculates end date' do
        event.update(end_date: nil, duration: 10)

        expect(event.end_date).to eq(Date.today + 10)
      end
    end

    context 'with end_date and duration' do
      it 'calculates start date' do
        event.update(start_date: nil, duration: 10, end_date: Date.today + 10)

        expect(event.start_date).to eq(Date.today)
      end
    end

    context 'with start_date and end_date' do
      it 'calculates duration' do
        event.update(end_date: Date.today + 10, duration: nil)

        expect(event.duration).to eq(10)
      end
    end
  end

end
