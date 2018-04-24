require 'csv'
require 'json'

EP = 'https://api.github.com/'.freeze

# get TOKEN from TOKEN file
token = ''
File.open('./TOKEN', 'r') do |f|
  token = f.read
end
TOKEN = "\"Authorization: token #{token}\"".freeze

# Get all team
def all_team
  `curl -o out.json -H #{TOKEN} #{EP}orgs/ie03-aizu/teams?per_page=100`

  all_team = {}
  # Preserve all teams to json file
  File.open('out.json', 'r') do |f|
    all_team = JSON.parse(f.read)
  end

  `rm out.json`

  all_team
end

# Store all team member data to temp/ dir
def store_all_team_member
  all_team.map { |item| item['id'] }.each do |id|
    `curl -o #{id}_members.json -H #{TOKEN} #{EP}teams/#{id}/members`
    `mv *.json ./temp/`
  end
end

# Create GitHub ID list from classroom_roster csv file
# Remove students who didn't have GitHub Name from the list
def github_id_list(classroom_roster)
  classroom_roster.reject { |arr| arr[1] == '' }.map { |elem| elem[1] }
end

def members?(team_users, classroom_roster)
  team_users.select do |item|
    github_id_list(classroom_roster).include?(item['login'])
  end.empty?
end

def clone_target_teams(classroom_roster)
  # Search teams which contains student who are in mailing list
  target_teams = []
  Dir.glob('./temp/*.json') do |file|
    puts "Seeing #{file}..."
    teamid = File.basename(file).split('_').first
    File.open(file, 'r') do |f|
      team_users = JSON.parse(f.read)
      # if there exists students who are contained to github_id_list,
      target_teams.push(teamid) unless members?(team_users, classroom_roster)
    end
  end
  target_teams
end

def clone_target_team_ids(classroom_roster)
  clone_target_teams(classroom_roster).map { |name| File.basename(name, '.*') }
end

def update(all_student, classroom)
  # Get all team and its members to local
  store_all_team_member

  # Drop header from classroom_roster.csv
  # Create a list which contains students on mailing list
  classroom_roster = all_student.drop(1).select do |item|
    student_id = item.first.split('_').first
    classroom.map(&:first).include?(student_id)
  end

  # Get all repositories for each detected team
  clone_target_team_ids(classroom_roster).each do |team_id|
    `curl -o #{team_id}_repos.json -H #{TOKEN} #{EP}teams/#{team_id}/repos`
    `mv *json ./repos/`
  end
end

unless ARGV[0].nil? || ARGV[1].nil?
  CSV.read(ARGV[1], headers: false).each do |data|
    all_student.push(data)
  end

  CSV.read(ARGV[0], headers: false).each do |data|
    classroom.push(data)
  end

  puts 'Update team list? (y/n)'
  print '> '
  input = STDIN.gets.chomp

  update(all_student, classroom) if input == 'y'
end

# remove old local repos
`rm -rf ./student_projects/*`

puts "Clone all repo.s created by students in #{ARGV[0]} to ./student_projects"
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
