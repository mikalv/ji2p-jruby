#-*- mode: ruby -*-
gemfile

packaging :jar

jruby_version = '9.2.9.0'

pom( 'org.jruby:jruby', jruby_version )
jar( 'org.jruby.rack:jruby-rack', '1.1.21', :exclusions => [ 'com.github.jnr:jffi', 'org.jruby:jruby-complete' ] )
jar( 'org.jruby:jruby-stdlib', jruby_version )

jruby_plugin!( :gem,
        :includeLibDirectoryInResources => true,
			  :includeRubygemsInTestResources => false,
        :includeRubygemsInResources => true )

plugin( :dependency, '2.8', :phase => 'prepare-package',
        :artifactItems => [ { :groupId => 'org.jruby',
                              :artifactId => 'jruby-stdlib',
                              :version => jruby_version,
                              :outputDirectory => '${project.build.outputDirectory}' } ] ) do
  execute_goal( :unpack )
end

resource :directory => '.', :includes => [ 'bin/**', 'config/**', 'lib/**' ]

use( :jruby_pack ) do
  pack_jar
end


# vim: syntax=Ruby