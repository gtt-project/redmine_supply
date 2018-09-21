scope 'projects/:project_id' do

  resources :supply_items, as: :project_supply_items do
    collection do
      get :autocomplete
    end
  end

  resources :issue_supply_items, only: %i( new create destroy ),
                                 as: :issue_supply_items

  resources :resource_categories, only: %i(new create edit update destroy),
                             as: :project_resource_categories

  resources :resource_items, only: %i(index new create edit update destroy),
                             as: :project_resource_items do
    collection do
      get :autocomplete
    end
  end

  resources :issue_resource_items, only: %i( new create destroy ),
                                   as: :project_issue_resource_items
end


