function getUriWithoutDashboard() {
    const reg = new RegExp('(\/dashboard.*$|\/$)');
    let baseUri = location.href;

    if (baseUri.match(reg)!= null) {
        baseUri = baseUri.replace(reg, '');
    }

    return baseUri;
}

function goToIssue(id) { 
    const baseUri = getUriWithoutDashboard();
    location.href = `${baseUri}/issues/${id}`;
}

function chooseProject(projectId) {
    if (projectId == "-1") {
        location.search = "";
    } else {
        location.search = `project_id=${projectId}`;   
    }
}

function init() {
    document.querySelector('#main-menu').remove();

    document.querySelectorAll('.select_project_item').forEach(item => {
        item.addEventListener('click', function() {
            chooseProject(this.dataset.id);
        })
    });

    const projectsSelector = document.querySelector('[name=project]');
    if (projectsSelector != null) {
        projectsSelector.addEventListener('change', function(e) {
            chooseProject(this.value);
        });
    }

    document.querySelector("#content").style.overflow = "hidden"; 
}