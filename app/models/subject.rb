class Subject < ApplicationRecord
  belongs_to :user
  has_many :collaborations, dependent: :destroy
  has_many :shared_users, through: :collaborations, source: :user
  # Roles:
  # owner: full control (already handled by belongs_to :user)
  # editor: can read and write
  # viewer: can only read
  has_many :lessons, dependent: :destroy
  validate :validate_schedule_data_format
  before_save :normalize_schedule_data

  def schedule_items
    schedule_data.to_s.split(/\r?\n/).map(&:strip).reject(&:blank?)
  end

  DAY_MAP = { 
    "So" => 0,
    "Mo" => 1,
    "Di" => 2,
    "Mi" => 3,
    "Do" => 4,
    "Fr" => 5,
    "Sa" => 6
  }

  def generate_lessons!(start_date, end_date)
    lookup = DAY_MAP.transform_keys(&:downcase)

    parsed_schedules = schedule_items.map do |row|
      parts = row.split(',')
      next if parts.length < 3

      day_index = lookup[parts[0].strip.downcase]
      next unless day_index # Skips if input doesn't match any day

      { day_index: day_index, time: parts[1].strip, dur: parts[2].to_i }
    end.compact

    (start_date..end_date).each do |date|
      parsed_schedules.each do |slot|
        if date.wday == slot[:day_index]
          # Using zone.parse is safer for Rails apps
          start_datetime = Time.zone.parse("#{date} #{slot[:time]}")

          self.lessons.create!(
            title: self.name,
            start_time: start_datetime,
            duration: slot[:dur]
          )
        end
      end
    end
  end

  def active_days
    # We use transform_keys(&:downcase) so we can look up "FR" or "fr" 
    # against our "Fr" map entry.
    lookup = DAY_MAP.transform_keys(&:downcase)

    schedule_items.map do |row| 
      day_input = row.split(',')[0].to_s.strip.downcase
      lookup[day_input] 
    end.compact.uniq.sort
  end

  def lessons_by_week_and_day
    lessons.includes(:phases)
      .where.not(start_time: nil)
      .order(:start_time)
    # Group by the actual Monday date of that week
      .group_by { |l| l.start_time.beginning_of_week.to_date }
      .transform_values do |week_lessons|
        week_lessons.group_by { |l| l.start_time.wday }
      end
  end

  def normalize_schedule_data
    return if schedule_data.blank?

    # Create a lookup for lowercase -> Proper Case ("fr" -> "Fr")
    case_lookup = DAY_MAP.keys.index_by(&:downcase)

    # Split into lines, fix the first part, then join back together
    normalized = schedule_items.map do |line|
      parts = line.split(',')
      day_input = parts[0].to_s.strip.downcase

      # If we find a match in our map, replace it with the "Correct" version
      if case_lookup[day_input]
        parts[0] = case_lookup[day_input]
      end

      parts.join(',')
    end

    self.schedule_data = normalized.join("\n")
  end

  def validate_schedule_data_format
    return if schedule_data.blank?

    # Create a lowercase list of valid days for comparison
    valid_days = DAY_MAP.keys.map(&:downcase)

    schedule_items.each_with_index do |line, index|
      parts = line.split(',').map(&:strip)

      # 1. Check for 3 parts (Day, Time, Duration)
      if parts.length != 3
        errors.add(:schedule_data, "line #{index + 1} is invalid: must be 'Day,Time,Duration' (e.g., Fr,10:15,2)")
        next
      end

      day, time, duration = parts

      # 2. Check if the Day is valid
      unless valid_days.include?(day.downcase)
        errors.add(:schedule_data, "line #{index + 1}: '#{day}' is not a valid day abbreviation (#{DAY_MAP.keys.join(', ')})")
      end

      # 3. Check if Time matches HH:MM format
      unless time.match?(/\A\d{1,2}:\d{2}\z/)
        errors.add(:schedule_data, "line #{index + 1}: '#{time}' is not a valid time format (use HH:MM like 08:30)")
      end

      # 4. Check if Duration is a number
      unless duration.match?(/\A\d+\z/)
        errors.add(:schedule_data, "line #{index + 1}: '#{duration}' must be a number")
      end
    end
  end

  def timetable_top_offset(hour_height = 60)
    # Default to 08:00 if start_time is missing
    start_str = schedule_data&.dig("start_time").presence || "08:00"
    time = Time.zone.parse(start_str)

    # Minutes from 06:00
    offset_minutes = (time.hour * 60 + time.min) - (6 * 60)
    (offset_minutes / 60.0) * hour_height
  end

  def timetable_height(hour_height = 60)
    # Default to 1 unit if missing
    units = (schedule_data&.dig("duration_units") || 1).to_i
    minutes = (units * 45) + ((units - 1) * 5)
    (minutes / 60.0) * hour_height
  end
  def parsed_schedule_rows
    schedule_items.map do |row|
      parts = row.split(',').map(&:strip)
      next if parts.length < 3

      {
        day_index: DAY_MAP[parts[0]].to_s, # "1", "2", etc.
        start_time: parts[1],
        duration_units: parts[2].to_i
      }
    end.compact
  end

  # Updated offset method that takes a specific start_time string
  def timetable_top_offset(start_time_str, hour_height = 60)
    time = Time.zone.parse(start_time_str) || Time.zone.parse("08:00")
    offset_minutes = (time.hour * 60 + time.min) - (6 * 60)
    (offset_minutes / 60.0) * hour_height
  end

  # Updated height method that takes specific units
  def timetable_height(units, hour_height = 60)
    u = units.to_i > 0 ? units.to_i : 1
    minutes = (u * 45) + ((u - 1) * 5)
    (minutes / 60.0) * hour_height
  end
end
