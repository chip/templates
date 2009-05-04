project = ask("\nWhat is your project name?")
automatic = yes?("\nAnswer 'yes' to all installation questions? (i.e., quicker installation process)")
#puts "You answered #{automatic}"

if automatic || yes?("\nInstall plugins?")
  puts "Setting up plugins for #{project}"
  plugin 'app_helpers',                 :git => 'git@github.com:chip/app_helpers.git'
  plugin 'ubistrano',                   :git => 'git@github.com:chip/ubistrano.git', :to => 'config/ubistrano'
  plugin 'haml',                        :git => "git://github.com/nex3/haml.git"
end

if automatic || yes?("\nInstall haml?")
  puts "Setting up haml for #{project}"
  gem 'haml'
  run "haml --rails summit from /Users/deploy/Sites/#{project}"
  rake "gems:install"
end

if automatic || yes?("\nSetup welcome page?")
  generate(:controller, "front")
  file 'app/views/front/welcome.html.haml', %q{Welcome Page}
  route "map.root :controller => 'front', :action => 'welcome'"
end

if automatic || yes?("\nSetup layout files?")
  # Setup shared header, footer, default layout
  file 'app/views/layouts/application.html.haml',
%q{= render :partial => '/shared/header'

%div
  = yield

= render :partial => '/shared/footer'
}  
  run "mkdir -p app/views/shared"
  file 'app/views/shared/_header.html.haml', <<-CODE
%html
  %head
    %title #{project}
    = javascript_include_tag 'prototype', 'scriptaculous.js?load=effects,builder', 'lightbox'
    = stylesheet_link_tag 'application', 'base', 'lightbox'
    
  %body
CODE
  file 'app/views/shared/_footer.html.haml', <<-CODE
%div
  %small Copyright &copy; 2009 #{project}
CODE
end

if automatic || yes?("\nSetup Ubistrano?")
  run "ubify ."
  project_name = project.to_s.downcase
  # cp deploy with project details filled in
  file 'config/deploy.rb', <<-CODE
set :ubistrano, {
  :application => :#{project_name},
  :platform    => :rails,  # :php, :rails, :sinatra
  :repository  => 'git@github.com:kyle/#{project_name}.git',

  :ec2 => {
    :access_key => '1GQQP5DQ76DFJ72CG5R2',
    :secret_key => 'UHPLkDA/yLRX5dBqNTuoJbfCDcz74NtPQycua4cO'
  },

  :mysql => {
    :root_password => 'Design01',
    :app_password  => 'Mysql2009'
    # Ubistrano creates a mysql user for each app
  },

  :production => {
    :domains => [ '#{project_name}.com' ],
    :ssl     => [ '#{project_name}.com' ],
    :host    => '75.101.132.135'
  },

  :staging => {
    :domains => [ '#{project_name}.railsint.com' ],
    :host    => '75.101.132.135'
  }
}

require 'ubistrano'

set :use_sudo, true

CODE

end

if automatic || yes?("\nSetup lightbox2? (prototype JS compatible)")
  run "mkdir tmp"
  run "cd tmp && wget http://www.lokeshdhakar.com/projects/lightbox2/releases/lightbox2.04.zip && unzip lightbox2.04.zip && cp css/lightbox.css ~/Sites/#{project}/public/stylesheets && cp js/* ~/Sites/#{project}/public/javascripts"
end

if automatic || yes?("\nSetup contact mailer?")
  # mailer setup
  generate :mailer, 'Contact'
end

if automatic || yes?("\nSetup .gitignore ?")
  #run "touch tmp/.gitignore log/.gitignore"
  run %{find . -type d -empty | grep -v "vendor" | grep -v ".git" | grep -v "tmp" | xargs -I xxx touch xxx/.gitignore}
  file '.gitignore', <<-END
.DS_Store
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
  END

  run "rm README"
  run "rm public/index.html"
  run "rm public/favicon.ico"
  run "rm public/robots.txt"
end

if automatic || yes?("\nCopy application_controller.rb to application.rb ?")
  run "cp app/controllers/application_controller.rb app/controllers/application.rb"
end

if automatic || yes?("\nDo you want to initialize a git repository")
  git :init

  # Setup remote github origin
  git :remote => "add origin git@github.com:kyle/summit.git"
  
  if yes?("\nDo you want to perform the initial commit to github?")
    git :add => "."
    git :commit => "-a -m 'Initial commit'"
    git :push => "master"
  end
end

if automatic || yes?("\nDisplay apache config for #{project} ?")
  puts "\n"
  puts "Please add this to /etc/apache/users/deploy.conf"
  puts "\n"
  puts "<VirtualHost *:80>
    ServerName #{project}.local
    DocumentRoot \"/Users/deploy/Sites/#{project}/public\"
    RailsEnv development
    ErrorLog /Users/deploy/Sites/#{project}/log/development.log
    PassengerLogLevel 1
  </VirtualHost>"
  puts "\n"
end

if automatic || yes?("\nDisplay /etc/hosts file for #{project} ?")
  puts "\nPlease add this to /etc/hosts"
  puts "\n"
  puts "127.0.0.1       #{project}.local"
  puts "\n"
end

if automatic || yes?("\nRestart apache?")
  run "sudo apachectl restart"
end
puts "\nProject setup for #{project} is complete!\n"