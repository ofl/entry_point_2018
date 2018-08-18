task :js_deps_install do
  sh "yarn install"
  sh "yarn run prod"
end
