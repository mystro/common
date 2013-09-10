# Changelog

## v0.1.11:
* fixes bug if disabled is not set

## v0.1.10:
* allow for disabling plugins

## v0.1.9:
* fucking bug in dns code again

## v0.1.8:
* revert new dsl creeping in when it wasnt supposed to

## v0.1.7:
* fix lingering error with Account.list change
* merge v0.1.6
* merge release v0.1.2
* new DSL framework
* ruby version file
* changelog rake tasks

## v0.1.6:

## v0.1.5:
* update rails to 3.2.14. tweak plugins jobs output to match qujo. fix issue with getting zones through fog
* smarter errors in dns connect. add and use Account#get instead of @list attr
* hard code rake version in Gemfile to match mystro server
* support for templates in userdata, handled like files, but processed through erubis
* merge release v0.1.2
* new DSL framework
* ruby version file
* changelog rake tasks

## v0.1.3:
* fixes bugs with dns usage and plugin methods when no plugins are defined
* update ruby version
* lock activesupport to same version as rails for mystro/server
* ruby-version, changelog task and add rake to Gemfile
* merge release v0.1.2
* new DSL framework
* ruby version file
* changelog rake tasks

## v0.1.2:
* new plugin support code for mystro-volley integration
* new DSL framework
* ruby version file
* changelog rake tasks

## v0.1.1:
* new DSL framework
* ruby version file

