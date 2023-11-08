# Dashboard 

Plugin adds a new item to the top menu and is presented as a dashboard that contains issues and their statuses in columns.  
Available a moving of issue cards between statuses, going to the issue by clicking on the issue card, changing statuses and projects colors.  

#### Supported languages:
- Russian
- English
- Ukrainian (thanks [Pavlo Vykhrov](https://github.com/Rosgard2012))
- Polish (thanks Wojtek Śmiałek)
- Portuguese Brazil (thanks [Fernando Hallberg](https://github.com/fernandohallberg))
- Croatian (thanks [Ivan Bratović](https://github.com/ivanbratovic))
- French (thanks [Timothy Anderson](https://github.com/Timothy-Anders0n))
- Swedish (thanks [Joaquim Homrighausen](https://github.com/joho1968))

### Features:  
- Displaying tasks of child projects (configurable)
- Custom coloring of projects and tasks badges
- "Drag-And-Drop" tasks between statuses
- Displaying of "closed" statuses and issues (configurable)
- Minimizing of "closed" issue cards (configurable)

### Installation:  
Just follow Redmine plugin installation steps (it doesn't require migration step)

### Notes: 
*if you want to change Redmine root page to this dashboard, you should replace string*
```ruby
root :to => 'welcome#index', :as => 'home'
```
*in Redmine default config file by path "config/routes.rb" to*
```ruby
root :to => 'dashboard#index', :as => 'home'
```

![Alt text](screenshots/gif1.gif)
![Alt text](screenshots/screen2.png)
