#Add the current directoy to the path Thor uses to look up files
#(check Thor notes)


#Thor uses source_paths to look up files that are sent to file-based Thor acitons
#https://github.com/erikhuda/thor/blob/master/lib%2Fthor%2Factions%2Ffile_manipulation.rb
#like copy_file and remove_file.

#We're redefining #source_path so we can add the template dir and copy files from it
#to the application


def source_paths
  Array(super)
  [File.expand_path(File.dirname(__FILE__))]
end


#Here we are removing the Gemfile and starting over
#You may want to tap and existing gemset or go this method to make it easier for
#others to check it out.
#Plus, you dont have to remove the comments in the Gemfile
remove_file "Gemfile"
run "touch Gemfile"
#be sure to add source at the top of the file
add_source 'https://rubygems.org'
gem 'rails', '4.2.1'
gem 'sqlite3'
gem 'uglifier'
gem 'coffee-rails'
gem 'turbolinks'
gem 'thin'
gem 'sass-rails'
gem 'sdoc', group: :doc

#gem and gem_group will work from Rails Template API
gem_group :development, :test do
  gem 'spring'
  gem 'quiet_assets'
  gem 'pry-rails'
  gem 'byebug'
  gem 'awesome_print'
  gem 'better_errors'
  gem 'binding_of_caller'
end

gem_group :test do
  gem 'guard-rspec'
  gem 'rspec-rails'
end

# for development unter cygwin
gem 'rb-fchange', platforms: [:mingw, :mswin, :x64_mingw], require: false, group: :development
# needed on windows platform
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw], group: :development

after_bundle do
  remove_dir 'test'
end

remove_file 'README.rdoc'
create_file 'README.md' do <<-TEXT
  #Markdown Stuff!

  Created with the help of Rails application templates
  TEXT
end

#run 'spring stop'
generate 'rspec:install'
run 'guard init'

rake 'db:migrate'

# Add meta tags and html5 shim

insert_into_file 'app/views/layouts/application.html.erb', :after => /<%= csrf_meta_tags %>/ do <<-TEXT
	<meta charset='utf-8'>
	<meta http-equiv='X-UA-Compatible' content='IE=edge'>
	<meta name='viewport' content='width=device-width, initial-scale=1'>
	<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
	<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
	<!--[if lt IE 9]>
	<script src='https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js'></script&gt;
	<script src='https://oss.maxcdn.com/respond/1.4.2/respond.min.js'></script&gt;
	<![endif]-->
	TEXT
end

git :init
git add: '.'
git commit: "-a -m 'Initial commit'"
