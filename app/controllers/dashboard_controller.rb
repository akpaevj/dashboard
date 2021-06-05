# frozen_string_literal: true

class DashboardController < ApplicationController
  def index
    @use_drop_down_menu = Setting.plugin_dashboard['use_drop_down_menu']
    @selected_project_id = params[:project_id].nil? ? -1 : params[:project_id].to_i
    show_sub_tasks = Setting.plugin_dashboard['display_child_projects_tasks']
    @show_project_badge = @selected_project_id == -1 || @selected_project_id != -1 && show_sub_tasks
    @use_drag_and_drop = Setting.plugin_dashboard['enable_drag_and_drop']
    @display_minimized_closed_issue_cards = Setting.plugin_dashboard['display_closed_statuses'] ? Setting.plugin_dashboard['display_minimized_closed_issue_cards'] : false
    @statuses = get_statuses
    @projects = get_projects
    @issues = get_issues(@selected_project_id, show_sub_tasks)
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
    data = {}
    items = Setting.plugin_dashboard['display_closed_statuses'] ? IssueStatus.sorted : IssueStatus.sorted.where('is_closed = false')
    items.each do |item|
      data[item.id] = {
        :name => item.name,
        :color => Setting.plugin_dashboard["status_color_" + item.id.to_s],
        :is_closed => item.is_closed
      }
    end
    data
  end

  def get_projects
    data = {-1 => {
      :name => l(:label_all),
      :color => '#4ec7ff'
    }}

    Project.visible.each do |item|
      data[item.id] = {
        :name => item.name,
        :color => Setting.plugin_dashboard["project_color_" + item.id.to_s]
      }
    end
    data
  end

  def add_children_ids(id_array, project)
    project.children.each do |child_project|
      id_array.push(child_project.id)
      add_children_ids(id_array, child_project)
    end
  end

  def get_issues(project_id, with_sub_tasks)
    id_array = []

    if project_id != -1
      id_array.push(project_id)
    end

    # fill array of children ids
    if project_id != -1 && with_sub_tasks
      project = Project.find(project_id)
      add_children_ids(id_array, project)
    end

    items = id_array.empty? ? Issue.visible : Issue.visible.where(:projects => {:id => id_array})

    unless Setting.plugin_dashboard['display_closed_statuses']
      items = items.open
    end

    data = items.map do |item|
      {
        :id => item.id,
        :subject => item.subject,
        :status_id => item.status.id,
        :project_id => item.project.id,
        :created_on => item.created_on,
        :author => item.author.name(User::USER_FORMATS[:firstname_lastname]),
        :executor => item.assigned_to.nil? ? '' : item.assigned_to.name
      }
    end
    data.sort_by { |item| item[:created_on] }
  end
end
