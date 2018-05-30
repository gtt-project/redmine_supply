Redmine Supply Plugin
=====================


Adding new units
----------------

1. Add the new unit to `config/units.yml` by appending it to the list of units
   already present. Do not change the ordering of the list or insert new
   elements anywhere in between as this will mix up the units of already
   existing records.
2. Add translations for your new unit under the key
   `label_supply_item_unit_your-unit`.
3. Restart the application for the changes to take effect.
