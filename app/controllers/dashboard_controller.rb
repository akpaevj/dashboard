class DashboardController < ApplicationController

  def index
    issues = []
    for issue in Issue.visible() do 
      executor = ""
      if !issue.assigned_to.nil?
        executor = issue.assigned_to.name()
      end

      issues.push({
        "id" => issue.id,
        "subject" => issue.subject,
        "status_id" => issue.status.id,
        "author" => issue.author.name(User::USER_FORMATS[:firstname_lastname]),
        "executor" => executor
      })
    end

    @statuses = []
    for status in IssueStatus.sorted() do
      if !status.is_closed
        @statuses.push({
          "id" => status.id,
          "name" => status.name,
          "color" => Setting.plugin_dashboard["status_color_" + status.id.to_s],
          "issues" => issues.select {|i| i["status_id"] == status.id }
        })
      end
    end
  end
end
