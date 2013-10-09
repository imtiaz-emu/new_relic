json.array!(@semesters) do |semester|
  json.extract! semester, :semester_no
  json.url semester_url(semester, format: :json)
end
