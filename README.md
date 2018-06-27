# Redmine Supply plugin

This plugin enables supply management for issues


## Requirements

- Redmine >= 3.4.0

## Installation

To install Redmine supply plugin, download or clone this repository in your Redmine installation plugins directory! 

`git clone https://hub.georepublic.net/gtt/redmine_supply.git`

Then run

`bundle install`

followed by

`bundle exec rake redmine:plugins:migrate`


After restarting Redmine, you should be able to see the Redmine Resource Manager in the Plugins page.

More information on installing Redmine plugins can be found here: http://www.redmine.org/wiki/redmine/Plugins



## Usage

- Add the new unit to `config/units.yml` by appending it to the list of units already present. 
    
- Do not change the ordering of the list or insert new elements anywhere in between as this will mix up the units of already existing records.

- Add translations for your new unit under the key `label_supply_item_unit_your-unit`.

- Restart the application for the changes to take effect.


## Version History

- 1.2.1 Fixes compatibility with old ruby versions 
- 1.2.0 Logs stock activities
- 1.1.0 Bugfix, make units configurable
- 1.0.1 Adds Japanese translation
  

## Authors

- [Jens Kraemer](https://github.com/jkraemer)

- [Daniel Kastl](https://github.com/dkastl)


## LICENSE

GPL v3.0
