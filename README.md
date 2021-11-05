# Redmine Supply plugin

This Redmine plugin enables supply management for issues.

## Requirements

 - Redmine >= 3.4.0

## Installation

To install Redmine Supply plugin, download or clone this repository in your Redmine installation plugins directory!

```
cd path/to/plugin/directory
git clone https://github.com/gtt-project/redmine_supply.git
```

Then run

```
bundle install
bundle exec rake redmine:plugins:migrate
```

After restarting Redmine, you should be able to see the Redmine Chatwoot plugin in the Plugins page.

More information on installing (and uninstalling) Redmine plugins can be found here: http://www.redmine.org/wiki/redmine/Plugins

## How to use

- Add the new unit to `config/units.yml` by appending it to the list of units already present.
- Do not change the ordering of the list or insert new elements anywhere in between as this will mix up the units of already existing records.
- Add translations for your new unit under the key `label_supply_item_unit_your-unit`.
- Restart the application for the changes to take effect.

## Contributing and Support

The GTT Project appreciates any [contributions](https://github.com/gtt-project/.github/blob/main/CONTRIBUTING.md)! Feel free to contact us for [reporting problems and support](https://github.com/gtt-project/.github/blob/main/CONTRIBUTING.md).

## Version History

See [all releases](https://github.com/gtt-project/redmine_supply/releases) with release notes.

## Authors

- [Jens Kraemer](https://github.com/jkraemer)
- [Daniel Kastl](https://github.com/dkastl)
- [Thibault Mutabazi](https://github.com/eyewritecode)
- [Ko Nagase](https://github.com/sanak)
- ... [and others](https://github.com/gtt-project/redmine_supply/graphs/contributors)

## LICENSE

This program is free software. See [LICENSE](LICENSE) for more information.
