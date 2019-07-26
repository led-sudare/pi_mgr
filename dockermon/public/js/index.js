$(document).ready(() => {
    let ws = new WebSocket('ws://' + window.location.host + '/ws');

    $.get('containers', (data) => {

        $.each(JSON.parse(data), (i, d) => {

            var ctx = document.getElementById(d.name).getContext('2d');
            var chartColors = {
                red: 'rgb(255, 99, 132)',
                orange: 'rgb(255, 159, 64)',
                yellow: 'rgb(255, 205, 86)',
                green: 'rgb(75, 192, 192)',
                blue: 'rgb(54, 162, 235)',
                purple: 'rgb(153, 102, 255)',
                grey: 'rgb(201, 203, 207)'
            };
            var chart = new Chart(ctx, {
                type: 'line',
                data: {
                    datasets: [
                        {
                            label: 'CPU Usage',
                            backgroundColor: chartColors.red,
                            borderColor: chartColors.red,
                            fill: false,
                            lineTension: 0,
                            borderDash: [8, 4],
                            data: []
                        },
                        {
                            label: 'Memory Usage',
                            backgroundColor: chartColors.blue,
                            borderColor: chartColors.blue,
                            fill: false,
                            lineTension: 0,
                            borderDash: [8, 4],
                            data: []
                        }
                    ]
                },
                options: {
                    scales: {
                        xAxes: [{
                            type: 'realtime',
                            realtime: {
                                duration: 60000
                            }
                        }],
                        yAxes: [{
                            ticks: {
                                beginAtZero: true,
                                min: 0,
                                max: 100
                            }
                        }]
                    }
                }
            });
            ws.onopen = () => console.log('connection opened');
            ws.onclose = () => console.log('connection closed');
            ws.onmessage = m => {
                var stat = JSON.parse(m.data);
                var x = Date.now();

                chart.data.datasets[0].data.push({
                    x: Date.now(),
                    y: stat[0].cpu
                });
                chart.data.datasets[1].data.push({
                    x: Date.now(),
                    y: stat[0].mem
                });
                console.log(m);
            }
        });

    });
});
