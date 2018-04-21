require 'csv'
require 'json'

EP = 'https://api.github.com/'.freeze

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

github_id_list = classroom_roster.reject { |arr| arr[1] == '' }.map do |elem|
  elem[1]
end

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
  `curl -o out.json -v -H "Authorization: token #{token}" #{EP}orgs/ie03-aizu/teams`

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
    `curl -o #{id}_members.json -H "Authorization: token #{token}" #{EP}teams/#{id}/members`
  end

  `mv *.json ./temp/`
end

# Search teams which contains student belonging to std5
target_teams = []
Dir.glob('./temp/*.json') do |file|
  teamid = File.basename(file).split('_').first
  File.open(file, 'r') do |f|
    jsonarr = JSON.parse(f.read)
    target_teams.push(teamid) unless jsonarr.select do |item|
      github_id_list.include?(item['login'])
    end.empty?
  end
end

target_team_ids = target_teams.map { |name| File.basename(name, '.*') }

# Get all repositories for each detected team
target_team_ids.each do |team_id|
  `curl -o #{id}_members.json -H "Authorization: token #{token}" #{EP}teams/#{team_id}/repos`
end


# Create repository list which should be cloned to local except hello world repository


