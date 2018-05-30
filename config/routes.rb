scope 'projects/:project_id' do

  resources :supply_items, as: :project_supply_items do
    collection do
      get :autocomplete
    end
  end

  resources :issue_supply_items, only: %i( new create destroy ),
                                 as: :issue_supply_items

end


