json.array!(@students) do |student|
  json.extract! student, :name
  json.url student_url(student, format: :json)
end
