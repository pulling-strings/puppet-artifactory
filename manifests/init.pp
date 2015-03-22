# Setting up artifactory
# based on http://devopsnet.com/2012/07/24/installing-artifactory-on-ubuntu/
class artifactory($pro=false){
  include artifactory::install
  include artifactory::nginx
}
