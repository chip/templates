
# Setup a new project
# rails project -m http://github.com:chip/templates/1.rb
#
# Or apply to an existing project
# rake rails:template LOCATION=http://github.com:chip/templates/1.rb

############## plugin commands #################

plugin 'app_helpers',                 :git => 'git@github.com:chip/app_helpers.git'
plugin 'ubistrano',                   :git => 'git@github.com:chip/ubistrano.git', :to => 'config/ubistrano'
plugin 'haml',                        :git => "git://github.com/nex3/haml.git"
plugin 'paperclip',                   :git => "git://github.com/thoughtbot/paperclip.git"
plugin 'simple_captcha',              :git => 'git://github.com/darrenterhune/simple_captcha.git'
plugin 'active_record_without_table', :git => 'git://github.com/jcnetdev/active_record_without_table.git'
plugin 'thinking-sphinx',             :git => 'git://github.com/freelancing-god/thinking-sphinx.git'
plugin 'will_paginate',               :git => 'git://github.com/mislav/will_paginate.git', :depth => 1, :tag => '2.3.2'
plugin 'state_select',                :git => 'git://github.com/sprsquish/state_select.git'
plugin 'country_select',              :git => 'git://github.com/rails/country_select.git'
plugin 'exception_notification',      :git => 'git://github.com/rails/exception_notification.git'
plugin 'restful-authentication',      :git => 'git://github.com/technoweenie/restful-authentication.git'
plugin 'role_requirement',            :git => 'git://github.com/timcharper/role_requirement.git'
plugin 'rails_money',                 :git => 'git://github.com/jfernandez/rails_money.git'
plugin 'prawnto',                     :git => 'git://github.com/thorny-sun/prawnto.git'
plugin 'seed-fu',                     :git => 'git://github.com/mbleigh/seed-fu.git'
plugin 'selenium-on-rails',           :git => 'git://github.com/paytonrules/selenium-on-rails.git'
plugin 'active_merchant',             :git => 'git://github.com/Shopify/active_merchant.git'

############## gem commands #################
gem 'rubyist-aasm', :version => '~> 2.0.2', :lib => 'aasm', :source => "http://gems.github.com"
gem "activemerchant", :lib => "active_merchant"
gem 'newgem', :version => '>= 1.2.3'
gem 'norman-haml_scaffold', :source => 'http://gems.github.com'
gem 'haml'
gem 'prawn'
gem 'populator', :lib => 'populator'
gem 'mislav-will_paginate', :version => '~> 2.2.3', :lib => 'will_paginate', :source => 'http://gems.github.com'
gem "paperclip"

##############  commands #################
generate("authenticated", "user session")

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
