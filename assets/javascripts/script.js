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

/** updates only of changed */
function setLocation(newLocation){
    if (!location.search && !newLocation) return;

    if (!location.search && newLocation){
        location.search = newLocation;
        return;
    }
    
    if (location.search && !newLocation){
        location.search = newLocation;
        return;
    }

    if (("?" + newLocation).localeCompare(location.search) == 0) return;    
    if (newLocation.localeCompare(location.search) == 0) return;    
    console.log("setLocation", {old: location.search, new:newLocation });
    location.search = newLocation;
}

function setAssignedTo(value) {
    //save to local storage
    const config = getConfig();
    config.assignedTo = value;
    setConfig(config);

    //update url
    const params = new URLSearchParams(window.location.search);
    if (value) {
        params.set('assigned_to', value);
    }else{
        params.delete('assigned_to');
    }
    setLocation(params.toString())

    //reflect to UI
    const assigned_to_me = document.querySelector('#assigned_to_me');
    const not_assigned = document.querySelector('#not_assigned');

    if (value == 'me'){
        if (assigned_to_me && !assigned_to_me.checked){
            console.log("switch assigned_to_me true");
            assigned_to_me.checked = true;            
        }
        if (not_assigned && not_assigned.checked){
            console.log("switch not_assigned false");
            not_assigned.checked = false;
        }
    }
    if (value == 'no_one'){
        if (assigned_to_me && assigned_to_me.checked){
            console.log("switch assigned_to_me false");
            assigned_to_me.checked = false;
        }
        if (not_assigned && !not_assigned.checked){
            console.log("switch not_assigned true");
            not_assigned.checked = true;
        }
    }
}

function getConfig(){
    return JSON.parse(localStorage.getItem("redmine-plugin-dashboard-config") ?? "{}");
}

function setConfig(config){
    localStorage.setItem("redmine-plugin-dashboard-config", JSON.stringify(config ?? {}));
}

function init(useDragAndDrop) {
    document.querySelector('#main-menu').remove();

    //reflect UI with proper checkbox values
    setAssignedTo(getConfig().assignedTo);

    document.querySelectorAll('.select_project_item').forEach(item => {
        item.addEventListener('click', function() {
            chooseProject(this.dataset.id);
        })
    });

    document.querySelector('#assigned_to_me')?.addEventListener('change', function () {
        setAssignedTo(this.checked ? "me" : null);
    });

    document.querySelector('#not_assigned')?.addEventListener('change', function () {
        setAssignedTo(this.checked ? "no_one" : null);
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