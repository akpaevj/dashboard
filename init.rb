Redmine::Plugin.register :dashboard_alt do
  name 'Dashboard Alt'
  author "Lavirlifiliol"
  description "Plugin adds an issues dashboard to the application "
  version '1.0.11'
  url 'https://github.com/lavirlifiliol/dashboard-alt'
  author_url 'https://github.com/lavirilifiliol'
  menu :top_menu, :dashboard_alt, { controller: 'dashboard_alt', action: 'index' }, caption: :top_menu_item_title, first: true
  settings :default => {:empty => true}, :partial => 'settings/dashboard_alt_settings'
end
