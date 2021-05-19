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

function init() {
    document.querySelector('#main-menu').remove();

    document.querySelectorAll('.select_project_item').forEach(item => {
        item.addEventListener('click', function() {
            if (this.dataset.id == "-1") {
                location.search = "";
            } else {
                location.search = `project_id=${this.dataset.id}`;   
            }
        })
    });

    document.querySelector("#content").style.overflow = "hidden"; 
}