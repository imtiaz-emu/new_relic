json.array!(@subjects) do |subject|
  json.extract! subject, :subject_name
  json.url subject_url(subject, format: :json)
end
