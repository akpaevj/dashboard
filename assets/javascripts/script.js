function getUriWithoutDashboard() {
    const reg = new RegExp('((?<=.+)\/dashboard$|\/$)');
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