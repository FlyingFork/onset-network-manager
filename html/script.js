// VARS
var charts = document.getElementById("charts");
var details = document.getElementById("details");
var settings = document.getElementById("settings");
var background = document.getElementById("background");

function hide(option) {
    if (option == "details" || option == "settings") {
        charts.style.display = "none";
    }

    if (option == "charts" || option == "settings") {
        details.style.display = "none";
    }

    if (option == "charts" || option == "details") {
        settings.style.display = "none";
    }
};

function clicked(option, ele) {
    hide(option);

    document.getElementById(option).style.display = "block";

    var elements = document.getElementsByClassName("item");
    for (i = 0; i < elements.length; i++) {
        var element = elements[i];
        if (element != ele) {
            element.style.color = "#FAF7FF";
        } else {
            element.style.color = "#36A2EB";
        }
    }
};

var slider = document.getElementById("myRange");
var output = document.getElementById("demo");
output.innerHTML = slider.value/100;

slider.oninput = function() {
    output.innerHTML = this.value/100;
    background.style.opacity = this.value/100;
}

var ctx1 = document.getElementById("send");
var sentChart = new Chart(ctx1, {
    type: 'line',
    data: {
        labels: ["10s","9s","8s","7s","6s","5s","4s","3s","2s","1s"],
        datasets: [
            {
                data: [],
                label: "Sending",
                borderColor: "#FF6384",
                backgroundColor: "rgba(255, 99, 132, 0.2)",
                fill: true
            }
        ]
    },
    options: {
        responsive: false,
        maintainAspectRatio: false,

        interaction: {
            intersect: false,
        },
        plugins: {
            legend: {
                display: true
            },
            title: {
                display: true,
                text: 'Bytes Send Chart',
                color: '#FFFFFF',
                font: {
                    size: 16
                }
            }
        }
    },
});

var ctx2 = document.getElementById("received");
var receivedChart = new Chart(ctx2, {
    type: 'line',
    data: {
        labels: ["10s","9s","8s","7s","6s","5s","4s","3s","2s","1s"],
        datasets: [
            {
                data: [],
                label: "Receiving",
                borderColor: "#FF6384",
                backgroundColor: "rgba(255, 99, 132, 0.2)",
                fill: true
            }
        ]
    },
    options: {
        responsive: false,
        maintainAspectRatio: false,

        interaction: {
            intersect: false,
        },
        plugins: {
            legend: {
                display: true
            },
            title: {
                display: true,
                text: 'Bytes Received Chart',
                color: '#FFFFFF',
                font: {
                    size: 16
                }
            }
        }
    },
});

function updateText(id, content) {
    document.getElementById(`${id}`).innerHTML = `${content}`; 
};
