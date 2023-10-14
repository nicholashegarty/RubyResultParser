# RubyResultParser  
Instructions to build Rails app that takes user files, parses and displays the results  
Instructions  

Installing dependencies:  
$ rails new ResultParser  
$ cd ResultParser  
Copy Gemfile from repo  
$ bundle install  
$ rails tailwindcss:install  
$ rails generate controller Parser  
$ rails generate rspec:install  
$ rails g rspec:controller parser  

Copying contents:  
Copy parser_controller.rb to app/controller/  
Copy config/routes.rb over  
Create two parser/views and copy contents in  
- home.html.erb  
- parsed.html.erb  
Copy test.txt file to public directory (used for rspec)  
Make folder public/uploads (for user files)  

RSpec:  
Replace spec folder with repo spec folder  
Run rspec (should return 5 passed)  

Tailwind:  
Copy views/layouts/application.html.erb (to fix width default)  
Copy config/tailwind.config.js (for custom colour)  
