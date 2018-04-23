require 'csv'
require 'json'

EP = 'https://api.github.com/'.freeze

# get TOKEN from TOKEN file
token = ''
File.open('./TOKEN', 'r') do |f|
  token = f.read
end
TOKEN = "\"Authorization: token #{token}\"".freeze

def update(all_student, classroom)
  # Get all teams from ie03-aizu organization
  `curl -o out.json -H #{TOKEN} #{EP}orgs/ie03-aizu/teams`

  all_team = {}
  # Preserve all teams to json file
  File.open('out.json', 'r') do |f|
    all_team = JSON.parse(f.read)
  end

  `rm out.json`

  # Get all member URL from API
  # After this op, temp/ dir contains all team member info.
  all_team.map { |item| item['id'] }.each do |id|
    `curl -o #{id}_members.json -H #{TOKEN} #{EP}teams/#{id}/members`
    `mv *.json ./temp/`
  end

  # Drop header from classroom_roster.csv
  # Create a list which contains students on mailing list
  classroom_roster = all_student.drop(1).select do |item|
    student_id = item.first.split('_').first
    classroom.map(&:first).include?(student_id)
  end

  # Remove students who didn't have GitHub Name from list
  github_id_list = classroom_roster.reject { |arr| arr[1] == '' }.map do |elem|
    elem[1]
  end

  # Search teams which contains student who are in mailing list
  target_teams = []
  Dir.glob('./temp/*.json') do |file|
    puts "Seeing #{file}..."
    teamid = File.basename(file).split('_').first
    File.open(file, 'r') do |f|
      jsonarr = JSON.parse(f.read)
      p jsonarr
      target_teams.push(teamid) unless jsonarr.select { |item| github_id_list.include?(item['login']) }.empty?
    end
  end

  target_team_ids = target_teams.map { |name| File.basename(name, '.*') }

  # Get all repositories for each detected team
  target_team_ids.each do |team_id|
    `curl -o #{team_id}_repos.json -H #{TOKEN} #{EP}teams/#{team_id}/repos`
    `mv *json ./repos/`
  end
end

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

unless ARGV[0].nil? || ARGV[1].nil?
  puts 'Update team list? (y/n)'
  print '> '
  input = STDIN.gets.chomp

  update(all_student, classroom) if input == 'y'
end

# remove old local repos
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
