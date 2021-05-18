class DashboardController < ApplicationController

  def index
    if request.query_parameters.key?("project_id")
      @selected_project_id = request.query_parameters["project_id"]
    else
      @selected_project_id = -1
    end

    @statuses = getStatuses()
    @projects = getProjects()
    @issues = getIssues(@selected_project_id)
  end

  private

  def getStatuses
    IssueStatus.sorted().where('is_closed = false').map { |item| {
      :id => item.id,
      :name => item.name,
      :color => Setting.plugin_dashboard["status_color_" + item.id.to_s]
      }
    }
  end

  def getProjects(project_id = -1)
    items = []

    items.push({
      :id => -1,
      :name => l(:label_all),
      :color => nil
    })

    Project.visible().where('status = 1').each do |item|
      items.push({
        :id => item.id,
        :name => item.name,
        :color => Setting.plugin_dashboard["project_color_" + item.id.to_s]
      })
    end

    items
  end

  def getIssues(project_id = -1)
    items = project_id == -1 ? (Issue.visible()) : (Issue.visible().where(:projects => {:id => project_id}))
    items.map { |item| {
        :id => item.id,
        :subject => item.subject,
        :status_id => item.status.id,
        :project => item.project,
        :created_at => item.start_date,
        :author => item.author.name(User::USER_FORMATS[:firstname_lastname]),
        :executor => item.assigned_to.nil? ? ('') : (item.assigned_to.name())
      }
    }
  end

end