### Changelog

##### v0.3.3.rc0:
* clean up plugin handling for gem-based plugins. minor tweak to compute.volume processing (this needs more work)
* some debug logging and tweaks around compute volumes

##### v0.3.2:
* use the released version of crackin

##### v0.3.1:
* crackin release working: FIRST! :)

##### v0.3.1.alpha2:
* think I've resolved problem with crackin release

##### v0.3.1.alpha1:
* trouble with crackin release process

##### v0.3.1.alpha0:
* add name to crackin config
* integrate crackin for gem releases
* update to fog 1.18
* fog issues resolved

##### v0.3.0:
* sync version with server

##### v0.2.0:
* tests green.
* conversion work completed... still want to test things a bit
* custom create method for balancers
* conversion work nearly completed. balancers working. environment creation cleaned up
* checkin
* fix tests to properly clean up after themselves
* refactor some of the fog extension work. monkey patch fog/dynect support.
* fixes for volume support
* getting compute and records conversion completed
* disable volumes to avoid fog bug
* volume modification (changing root volume size) is working, but there's a bug in fog
* conversion work
* refactor data call to to_hash
* dsl conversion
* check in
* add access to config, allow to disable in configuration
* add raw attribute to listener
* cleanup
* add _raw to decoded object
* dynect record destroy working. refactor tests to use configuration file. add _raw attribute to models, this can contain source object (fog object). reopen fog dynect records to add find_by_name.
* working with shawncatz/fog fork
* dynect
* some refactoring, support for dynect started
* refactor to shared examples
* compute, balancers and records working. includes tests for cloud operations and models
* converted to new format, organizations now use new connect framework, started support for DNS
* balancers
* rspec integration
* add LIST to Version class. makes it easier to handle release tasks
* providers support
* orgs

##### v0.1.11:
* fixes bug if disabled is not set

##### v0.1.10:
* allow for disabling plugins

##### v0.1.9:
* fucking bug in dns code again

##### v0.1.8:
* revert new dsl creeping in when it wasnt supposed to

##### v0.1.7:
* fix lingering error with Account.list change
* merge v0.1.6
* merge release v0.1.2
* new DSL framework
* ruby version file
* changelog rake tasks

##### v0.1.6:
* update rails to 3.2.14. tweak plugins jobs output to match qujo. fix issue with getting zones through fog
* smarter errors in dns connect. add and use Account#get instead of @list attr
* merge
* merge release v0.1.2
* new DSL framework
* ruby version file
* changelog rake tasks

##### v0.1.5:


##### v0.1.4:
* merge
* hard code rake version in Gemfile to match mystro server
* support for templates in userdata, handled like files, but processed through erubis

##### v0.1.3:
* fixes bugs with dns usage and plugin methods when no plugins are defined
* update ruby version
* lock activesupport to same version as rails for mystro/server
* ruby-version, changelog task and add rake to Gemfile
* merge release v0.1.2
* new DSL framework
* ruby version file
* changelog rake tasks

##### v0.1.2:
* new plugin support code for mystro-volley integration
* new DSL framework
* ruby version file
* changelog rake tasks

##### v0.1.1:
* new DSL framework
* ruby version file

##### v0.1.0:


