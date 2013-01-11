load 'deploy' if respond_to?(:namespace) # cap2 differentiator

set :application, "caat-samples"
set :deploy_to, "/home/hormigon/caat-samples"
set :deploy_via, :copy #the deploy is low...
#set :deploy_via, :rsync_with_remote_cache #strategy doesnt exist
set :repository, "build" 
set :scm, :none 
set :copy_compression, :gzip
set :use_sudo, false
set :domain, 'cooph.com.ar'
set :user, 'hormigon'

role :web, 'cooph.com.ar'

before 'deploy:update_code' do
  run_locally 'rm -rf build/*'
  run_locally 'middleman build'
end
