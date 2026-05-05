json.extract! lesson, :id, :title, :start_time, :duration, :created_at, :updated_at
json.url lesson_url(lesson, format: :json)
