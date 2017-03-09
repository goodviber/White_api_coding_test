class Event < ActiveRecord::Base
  belongs_to :user

  ATTRIBUTES = [:name, :description, :location, :start_date, :end_date]

  validates :user_id, presence: true
  validate :start_date_before_end_date
  validate :start_date_before_today, on: :create
  validate :subset_attributes_present

  def start_date_before_today
    unless self.start_date.nil? || self.end_date.nil?
      if self.start_date < Date.today
        errors.add(:start_date, "Start date should be from today")
      end
    end
  end

  def start_date_before_end_date
    unless self.start_date.nil? || self.end_date.nil?
      if self.start_date >= self.end_date
        errors.add(:start_date, "Start date should be before end date")
      end
    end
  end

  def tag_as_removed
    self.removed = true
    self.save
  end

  def published?
    all_attributes_present?
  end

  before_validation :calculate_dates_and_duration

  private

  def subset_attributes_present
    unless ATTRIBUTES.any? { |attr| self[attr].present? }
      errors.add(:base, "Event needs at least one field")
    end
  end

  def all_attributes_present?
    ATTRIBUTES.all? { |attr| self[attr].present? }
  end

  def calculate_dates_and_duration
    self.start_date = self.end_date - self.duration if duration? && end_date? && !start_date?
    self.end_date = self.start_date + self.duration if start_date && duration? && !end_date?
    self.duration = (self.end_date - self.start_date).to_i if start_date? && end_date? && !duration
  end

end
