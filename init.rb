Redmine::Plugin.register :dashboard do
  name 'Dashboard'
  author 'Акпаев Е.А.'
  description 'Панель статусов с отображением задач в колонках'
  version '0.0.2'
  url ''
  author_url 'https://github.com/akpaevj'
  menu :top_menu, :dashboard, { controller: 'dashboard', action: 'index' }, caption: 'Панель задач', first: true
  settings :default => {:empty => true}, :partial => 'settings/dashboard_settings'
end