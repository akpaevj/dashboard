# Dashboard 

Plugin adds an issues dashboard to the application.
This dashboard looks like an usual Kanban desk and presents a column for each status that contains issue cards.
You can follow to any issue just by clicking on the issue card. Also it adds a new item to the top menu.  

You can adapt the plugin in settings by changing projects and statuses colors that will be displayed on the dashboard page

### Installation:  
Just follow Redmine plugin installation steps (it doesn't require migration step)

### Notes: 
*if you want to change Redmine root page to this dashboard, you should replace string*
```ruby
root :to => 'welcome#index', :as => 'home'
```
*at Redmine default config file by path "config/routes.rb" to*
```ruby
root :to => 'dashboard#index', :as => 'home'
```

![Alt text](screenshots/screen1.png)
![Alt text](screenshots/screen2.png)