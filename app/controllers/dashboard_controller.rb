class DashboardController < ApplicationController

  def index
    if request.query_parameters.key?("project_id")
      @selected_project_id = request.query_parameters["project_id"]
    else
      @selected_project_id = -1
    end

    @statuses = getData(@selected_project_id)
    @projects = getProjects(@selected_project_id)
  end
  
end

private

def getProjects(selected_project_id = -1)
  projects = []
  projects.push({
      "id" => -1,
      "name" => l(:label_all)
    })

  for project in Project.visible() do
    selected = ""
    if selected_project_id.to_s == project.id.to_s
      selected = "selected"
    end
    
    projects.push({
      "id" => project.id,
      "name" => project.name,
      "color" => Setting.plugin_dashboard["project_color_" + project.id.to_s],
      "selected" => selected
    })
  end
  return projects
end

def getData(project_id = -1)
  issues = []
  for issue in Issue.visible() do 
    if project_id != -1 && issue.project_id.to_s != project_id.to_s
      next
    end

    executor = ""
    if !issue.assigned_to.nil?
      executor = issue.assigned_to.name()
    end

    issues.push({
      "id" => issue.id,
      "subject" => issue.subject,
      "status_id" => issue.status.id,
      "project" => issue.project.name,
      "project_id" => issue.project.id,
      "created_at" => issue.start_date,
      "author" => issue.author.name(User::USER_FORMATS[:firstname_lastname]),
      "executor" => executor
    })
  end

  statuses = []
  for status in IssueStatus.sorted() do
    if !status.is_closed
      statuses.push({
        "id" => status.id,
        "name" => status.name,
        "color" => Setting.plugin_dashboard["status_color_" + status.id.to_s],
        "issues" => issues.select {|i| i["status_id"] == status.id }
      })
    end
  end
  return statuses
end