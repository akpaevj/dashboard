function hslToHex(h, s, l) {
  l /= 100;
  const a = s * Math.min(l, 1 - l) / 100;
  const f = n => {
    const k = (n + h / 30) % 12;
    const color = l - a * Math.max(Math.min(k - 3, 9 - k, 1), -1);
    return Math.round(255 * color).toString(16).padStart(2, '0');
  };
  return `#${f(0)}${f(8)}${f(4)}`;
}

function genereateStatusesColors() {
  const items = document.querySelectorAll('input[name^="settings[status_color"]');
  const degreePerItem = 360 / items.length;
  let currentDegree = 360 - degreePerItem;

  items.forEach(function(item) {
    if (currentDegree < 0) {
      currentDegree = 0;
    }
    item.value = hslToHex(currentDegree, 100, 50);
    currentDegree -= degreePerItem;
  }); 
}

function genereateProjectColors() {
  const items = document.querySelectorAll('input[name^="settings[project_color"]');
  const degreePerItem = 360 / items.length;
  let currentDegree = 0;

  items.forEach(function(item) {
    if (currentDegree > 360) {
      currentDegree = 360;
    }
    item.value = hslToHex(currentDegree, 100, 45);
    currentDegree += degreePerItem;
  }); 
}

function generateColors() {
  genereateStatusesColors();
  genereateProjectColors();
}