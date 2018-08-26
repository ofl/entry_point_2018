task :js_deps_install do
  puts 'start install js dependencies'
  sh 'yarn install'
  puts 'end install js dependencies'

  puts 'start precompile assets'
  sh 'yarn run prod'
  puts 'end precompile assets'
end
