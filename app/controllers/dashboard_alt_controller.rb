# frozen_string_literal: true
require 'date'

class DashboardAltController < ApplicationController
  def index
    @use_drop_down_menu = Setting.plugin_dashboard_alt['use_drop_down_menu']
    @selected_status_id  = params[:project_id].nil? ? -1 : params[:project_id].to_i
    show_sub_tasks = Setting.plugin_dashboard_alt['display_child_projects_tasks']
    @use_drag_and_drop = Setting.plugin_dashboard_alt['enable_drag_and_drop']
    @display_minimized_closed_issue_cards = Setting.plugin_dashboard_alt['display_closed_statuses'] ? Setting.plugin_dashboard_alt['display_minimized_closed_issue_cards'] : false
    @statuses = get_statuses
    @projects = get_projects(show_sub_tasks)
    @issues = get_issues(@selected_status_id, show_sub_tasks) 
  end

  def set_issue_status
    issue_id = params[:issue_id].to_i
    status_id = params[:status_id].to_i

    issue = Issue.find(issue_id)

    if issue.new_statuses_allowed_to.select { |item| item.id == status_id }.any?
      issue.init_journal(User.current)
      issue.status_id = status_id
      issue.save
      head :ok
    else
      head :forbidden
    end
  end

  private

  def get_statuses
    data = {-1 => {
      :name => l(:label_all),
      :color => '#4ec7ff',
      :is_closed => false,
    }}
    items = Setting.plugin_dashboard_alt['display_closed_statuses'] ? IssueStatus.sorted : IssueStatus.sorted.where('is_closed = false')
    items.each do |item|
      data[item.id] = {
        :name => item.name,
        :color => Setting.plugin_dashboard_alt["status_color_" + item.id.to_s],
        :is_closed => item.is_closed
      }
    end
    data
  end

  def get_parent(project)
    path = []
    parent = project
    while !(parent.nil?)
      path << parent.name + (path.empty? ? "" : "/")
      parent = parent.parent
    end
    path.reverse
  end

  def project_key(project)
    selector = {:project_id => project.id}
    unless @selected_status_id == -1
      selector[:status_id] = @selected_status_id
    end
    Issue.visible.where(selector).map{ |i| i.updated_on }.max || DateTime.new(1970, 1,1)
  end

  def get_projects(show_sub_tasks)
    data = {}

    Project.visible.each do |item|
      path = get_parent(item)
      if (path.length == 1 || show_sub_tasks) && item.issues.length > 0
        data[item.id] = {
          :name => item.name,
          :color => Setting.plugin_dashboard_alt["project_color_" + item.id.to_s],
          :parent => path,
          :sort_key => project_key(item),
        }
      end
    end
    data.sort_by{ |k, v| v[:sort_key] }.reverse.to_h
  end

  def add_children_ids(id_array, project)
    project.children.each do |child_project|
      id_array.push(child_project.id)
      add_children_ids(id_array, child_project)
    end
  end

  def get_issues(status_id, with_sub_tasks)
    # id_array = []

    # if with_sub_tasks
    #   Project.visible.each do |project|
    #     id_array.push(project.id)
    #   end
    # end

    # # fill array of children ids
    # if with_sub_tasks
    #    project = Project.find(project_id)
    #    add_children_ids(id_array, project)
    #  end

    items = status_id == -1 ? Issue.visible : Issue.visible.where(:status_id =>  status_id)

    unless Setting.plugin_dashboard_alt['display_closed_statuses']
      items = items.open
    end

    data = items.map do |item|
      {
        :id => item.id,
        :subject => item.subject,
        :status_id => item.status.id,
        :project_id => item.project.id,
        :created_on => item.created_on,
        :updated_on => item.updated_on,
        :author => item.author.name(User::USER_FORMATS[:firstname_lastname]),
        :executor => item.assigned_to.nil? ? '' : item.assigned_to.name
      }
    end
    data.sort_by { |item| item[:updated_on] }.reverse
  end
end
