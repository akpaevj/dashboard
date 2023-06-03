function getUriWithoutDashboard() {
    const reg = new RegExp('(\\/dashboard.*$|\\/$|\\?.*$)');
    let baseUri = location.href;

    if (baseUri.match(reg)!= null) {
        baseUri = baseUri.replace(reg, '');
    }

    return baseUri;
}

function getUriWithDashboard() {
    const baseUri = getUriWithoutDashboard();
    return `${baseUri}/dashboard`;
}

function goToIssue(id) { 
    const baseUri = getUriWithoutDashboard();
    location.href = `${baseUri}/issues/${id}`;
}

function chooseProject(projectId) {
    const params = new URLSearchParams(window.location.search);
    if (projectId == "-1") {
        params.delete('project_id');
    } else {
        params.set('project_id', projectId);
    }
    location.search = params.toString();
}

async function setIssueStatus(issueId, statusId, item, oldContainer, oldIndex) { 
    const response = await fetch(`${getUriWithDashboard()}/set_issue_status/${issueId}/${statusId}`);
    if (!response.ok) {
        oldContainer.insertBefore(item, oldContainer.childNodes[oldIndex + 1]);
    }
}

function init(useDragAndDrop) {
    document.querySelector('#main-menu').remove();

    document.querySelectorAll('.select_project_item').forEach(item => {
        item.addEventListener('click', function() {
            chooseProject(this.dataset.id);
        })
    });

    document.querySelector('#assigned_to_me')?.addEventListener('change', function () {
        const params = new URLSearchParams(window.location.search);
        if (this.checked) {
            params.set('assigned_to', "me");
        }else{
            params.delete('assigned_to');
        }
        location.search = params.toString();
    });

    document.querySelector('#not_assigned')?.addEventListener('change', function () {
        const params = new URLSearchParams(window.location.search);
        if (this.checked) {
            params.set('assigned_to', "no_one");
        }else{
            params.delete('assigned_to');
        }
        location.search = params.toString();
    });

    const projectsSelector = document.querySelector('#select_project');
    if (projectsSelector != null) {
        projectsSelector.addEventListener('change', function(e) {
            chooseProject(this.value);
        });
    }

    document.querySelector("#content").style.overflow = "hidden"; 

    if (useDragAndDrop) {
        document.querySelectorAll('.status_column_closed_issues, .status_column_issues').forEach(item => {
            new Sortable(item, {
                group: 'issues',
                animation: 150,
                draggable: '.issue_card',
                onEnd: async function(evt) {
                    const newStatus = evt.to.closest('.status_column').dataset.id;
                    const issueId = evt.item.dataset.id;
    
                    await setIssueStatus(issueId, newStatus, evt.item, evt.from, evt.oldIndex);
                }
            })
        })
    }
}