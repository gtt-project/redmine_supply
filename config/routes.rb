scope 'projects/:project_id' do
  resources :supply_items, only: %i(new create edit update destroy),
                           as: :project_supply_items
end

