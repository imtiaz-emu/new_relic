json.array!(@registrations) do |registration|
  json.extract! registration, :student_id_card, :semester_no, :subject_name
  json.url registration_url(registration, format: :json)
end
