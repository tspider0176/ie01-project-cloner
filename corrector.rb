require 'csv'
require 'json'

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

# output student ID, name and GitHub ID for std5
puts classroom_roster.reject { |arr| arr[1] == '' }.map { |item| item.join(',') }.join("\n")

puts 'Update team list?:(y/n)'
printf '> '
input = gets.chomp

if input != 'n'
  # get TOKEN from TOKEN file
  token = ''
  File.open('./TOKEN', 'r') do |f|
    token = f.read
  end

  # Get by GitHub API
  `curl -o out.json -v -H "Authorization: token #{token}" https://api.github.com/orgs/ie03-aizu/teams`

  hash = {}
  # Get all teams from out.json
  File.open('out.json', 'r') do |f|
    hash = JSON.parse(f.read)
  end

  `rm out.json`

  # Get team id list
  id_list = hash.map do |item|
    item['id']
  end

  # Get value all of member URL from key 'members_url'
  id_list.each do |id|
    puts 'getting members for each team ID...'
    `curl -o #{id}_members.json -v -H "Authorization: token #{token}" https://api.github.com/teams/#{id}/members`
  end

  `mv *.json ./temp/`
end
