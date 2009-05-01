# To Do
#
# 1. Need static url for template
# 2. Initialize project with haml
#    cd ../; haml --rails project
# script/generate controller front
# cat "WGA Welcome Page" > project/app/views/front/welcome.html.haml
# 3. Setup map.root in routes.rb for front controller
# Setup shared header, footer, default layout
# 4. Why is norman-haml_scaffold not installing?
# 5. "ask" before doing initial git commit
# ubify
# cp deploy with project details filled in

# Setup a new project
# rails project -m http://
#
# Or apply to an existing project
# rake rails:template LOCATION=

############## plugin commands #################
plugin 'app_helpers',                 :git => 'git@github.com:chip/app_helpers.git'
plugin 'ubistrano',                   :git => 'git@github.com:chip/ubistrano.git', :to => 'config/ubistrano'
plugin 'haml',                        :git => "git://github.com/nex3/haml.git"
plugin 'paperclip',                   :git => "git://github.com/thoughtbot/paperclip.git"
plugin 'simple_captcha',              :git => 'git://github.com/darrenterhune/simple_captcha.git'
plugin 'will_paginate',               :git => 'git://github.com/mislav/will_paginate.git', :depth => 1, :tag => '2.3.2'
plugin 'state_select',                :git => 'git://github.com/sprsquish/state_select.git'

############## gem commands #################
gem 'newgem', :version => '>= 1.2.3'
#gem 'norman-haml_scaffold', :source => 'http://gems.github.com'
gem 'haml'
gem 'mislav-will_paginate', :version => '~> 2.2.3', :lib => 'will_paginate', :source => 'http://gems.github.com'

##############  commands #################
#generate("authenticated", "user session")

run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
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

git :init
git :add => "."
git :commit => "-a -m 'Initial commit'"

# Setup remote github origin
#  git remote add origin git@github.com:kyle/wga.git
# push master
