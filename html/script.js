
var time = ["10s","9s","8s","7s","6s","5s","4s","3s","2s","1s"];
var send = [];
var receive = [];

var myData = {
    labels: time,
    datasets: [
        { 
            data: send,
            label: "Sending",
            borderColor: "#36A2EB",
            backgroundColor: "rgba(54, 162, 235, 0.2)",
            fill: true
        },
        { 
            data: receive,
            label: "Receiving",
            borderColor: "#FF6384",
            backgroundColor: "rgba(255, 99, 132, 0.2)",
            fill: true
        }
    ]
}

var ctx = document.getElementById("chart");
var myChart = new Chart(ctx, {
    type: 'line',
    data: myData,
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
                text: 'Network Chart',
                color: '#FFFFFF',
                font: {
                    size: 16
                }
            }
        },
    },
});

function updateChart(index, val) {
    myChart.data.datasets[index].data = val;
    myChart.update();
}

function setText(content) {
    document.getElementById("text").innerHTML = content;
}