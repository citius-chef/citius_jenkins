name 'citius_jenkins'
maintainer 'The Authors'
maintainer_email 'you@example.com'
license 'all_rights'
description 'Installs/Configures citius_jenkins'
long_description 'Installs/Configures citius_jenkins'
version '0.1.5'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/citius_jenkins/issues' if respond_to?(:issues_url)

# The `source_url` points to the development reposiory for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/citius_jenkins' if respond_to?(:source_url)


depends 'jenkins', '~> 4.2.1'
#depends 'apache2', '~> 3.2.2'
depends 'iptables', '~> 3.1.0'
depends 'java', '~> 1.47.0'
depends 'sudo', '~> 3.3.1'
depends 'git', '~> 6.0.0'