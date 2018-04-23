require 'csv'
require 'json'

EP = 'https://api.github.com/'.freeze

# get TOKEN from TOKEN file
token = ''
File.open('./TOKEN', 'r') do |f|
  token = f.read
end
TOKEN = "\"Authorization: token #{token}\"".freeze

all_student = []
classroom = []
unless ARGV[0].nil? || ARGV[1].nil?
  CSV.read(ARGV[1], headers: false).each do |data|
    all_student.push(data)
  end

  CSV.read(ARGV[0], headers: false).each do |data|
    classroom.push(data)
  end
end

puts 'Update team list?:(y/n)'
printf '> '
input = gets.chomp

if input == 'y'
  # Get by GitHub API
  `curl -o out.json -H #{TOKEN} #{EP}orgs/ie03-aizu/teams`

  hash = {}
  # Get all teams from out.json
  File.open('out.json', 'r') do |f|
    hash = JSON.parse(f.read)
  end

  `rm out.json`

  # Get all of member URL from key 'members_url'
  hash.map { |item| item['id'] }.each do |id|
    `curl -o #{id}_members.json -H #{TOKEN} #{EP}teams/#{id}/members`
    `mv *.json ./temp/`
  end

  # Search teams which contains student belonging to given classroom
  target_teams = []
  classroom_roster = all_student.drop(1).select do |item|
    classroom.map(&:first).include?(item.first.split('_').first)
  end

  github_id_list = classroom_roster.reject { |arr| arr[1] == '' }.map do |elem|
    elem[1]
  end

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
    `curl -o #{team_id}_repos.json -H #{TOKEN} #{EP}teams/#{team_id}/repos`
    `mv *json ./repos/`
  end
end

# remove exists local repos
`rm -rf ./student_projects/*`

# Create repository URL list which should be cloned to local
Dir.glob('./repos/*.json') do |file|
  File.open(file, 'r') do |f|
    jsonarr = JSON.parse(f.read)
    ssh_url = jsonarr.first['ssh_url']
    puts '----------'
    dir_name = File.basename(File.basename(ssh_url), '.*')
    `git clone #{ssh_url} ./student_projects/#{dir_name}`
  end
end
