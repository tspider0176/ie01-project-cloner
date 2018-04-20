require 'csv'

roster_csv = CSV.read('classroom_roster.csv', headers: false)
mailing_list_csv = CSV.read('11-3002-IE03-std5.csv', headers: false)

all_student = []
roster_csv.each do |data|
  all_student.push(data)
end

classroom = []
mailing_list_csv.each do |data|
  classroom.push(data)
end

classroom_roster = all_student.drop(1).select do |item|
  classroom.map(&:first).include?(item.first.split('_').first)
end

p classroom_roster
