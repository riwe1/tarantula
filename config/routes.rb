ActionController::Routing::Routes.draw do |map|
  map.connect '', :controller => "home", :action => "index"

  map.resources :password_resets

  map.resource :archive, :only => [:destroy, :create],
    :path_prefix => '/projects/:project_id/:resources',
    :controller => 'archives'

  map.resources :projects, :member => {
    :priorities => :get,
    :deleted => :delete, :products => :get},
    :collection => {:deleted => :get} do |project|

    project.resources :users do |user|
      user.resources :executions
      user.resource :test_area
      user.resource :test_object
      user.resources :report_data
    end

    project.resources :test_sets do |tset|
      tset.resources :cases, :collection => {:not_in_set => :get}
    end
    project.resources :attachments
    project.resources :cases
    project.resources :executions
    project.resources :requirements
    project.resources :tags
    project.resources :tasks
    project.resources :test_objects do |tob|
      tob.resources :attachments
    end
    project.resources :test_areas
    project.resources :bug_trackers, :member => {:products => :get}
    project.resources :bugs
  end

  map.resources :requirements do |req|
    req.resources :cases, :only => [:index]
    req.resources :attachments
  end

  map.resources :test_sets do |tset|
    tset.resources :cases, :collection => {:not_in_set => :get}
  end

  map.resources :cases, :member => {:change_history => :get} do |tcase|
    tcase.resources :attachments
    tcase.resources :tasks
    tcase.resources :requirements, :only => [:index]
  end

  map.resources :case_executions, :has_many => :attachments

  map.resources :executions do |texec|
    texec.resources :case_executions
  end

  map.resources :test_objects, :only => [:show] do |tobs|
    tobs.resources :attachments
  end

  map.resources :users, :member => {:selected_project => :put, :permissions => :get, :available_groups => :get},
    :collection => {:deleted => :get} do |users|
    users.resources :projects, :member => {:group => :get}, :collection => {:deleted => :get}
    users.resources :executions
    users.resources :tasks
  end

  map.resources :bug_trackers, :member => {:products => :get}

  map.resources :customer_configs
  map.connect 'restart', :controller => 'customer_configs', :action => 'restart'

  map.resource :report, :member => {:dashboard => :get,
                                    :test_result_status => :get,
                                    :results_by_test_object => :get,
                                    :case_execution_list => :get,
                                    :test_efficiency => :get,
                                    :status => :get,
                                    :requirement_coverage => :get,
                                    :bug_trend => :get,
                                    :workload => :get},
               :controller => 'report'

  map.resource :home, :member => {:login => [:get, :post],
                                  :logout => :get,
                                  :index => :get},
               :controller => 'home'

  map.resource :import, :member => {:doors => [:get, :post]},
               :controller => 'import'

end
