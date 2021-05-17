function getUriWithoutDashboard() {
    const reg = new RegExp('((?<=.+)\/dashboard.*$|\/$)');
    let baseUri = location.pathname;

    if (baseUri.match(reg)!= null) {
        baseUri = baseUri.replace(reg, '');
    }

    return baseUri;
}

function goToIssue(id) {
    const baseUri = getUriWithoutDashboard();
    location.pathname = `${baseUri}/issues/${id}`;
}

function init() {
    document.querySelector('#main-menu').remove();

    document.querySelector('[name=project]').addEventListener('change', function(e) {
        if (this.value == "-1") {
            location.search = "";
        } else {
            location.search = `project_id=${this.value}`;   
        }
    });
}