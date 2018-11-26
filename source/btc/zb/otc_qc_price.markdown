---
layout: post
title: "zb.com QC币OTC价格趋势"
categories: [QC,BTC,zb.com,OTC,QC价格趋势]
---

<script src="https://cdn.hcharts.cn/highcharts/highcharts.js"></script>
<script src="https://cdn.hcharts.cn/highcharts-plugins/highcharts-zh_CN.js"></script>

> QC币全称为Qcash，是基于量子链智能合约的数字货币，由Qcash基金会发行的独立数字货币。

####最新价格

卖价 ¥<span id='current_price_1' style="color:green;font-size:20px;">获取中...</span>

买价 ¥<span id='current_price_2' style="color:red;font-size:20px;">获取中...</span>

####历史价格

<div id="container" style="width: 100%;height:400px;"></div>

<br>
* QC币在[https://www.zb.com](https://www.zb.com)可以用于交易各种数字币种.
* 此QC币价格趋势图表线数据为每小时从`zb.com`抓取,可用于投资者判断交易
* 价格走低,说明套现离场情绪偏高
* 价格走高,说明积极入场情绪偏高

<script>
    var domain = "https://btc.api.sargeraswang.com";
    $.getJSON(domain+'/zb/otc/qc/current', function (data) {
        $("#current_price_1").text(data.result["1"].price);
        $("#current_price_2").text(data.result["2"].price);
    });

    var chart = null;
    $.getJSON(domain+'/zb/otc/qc/list', function (data) {
        chart = Highcharts.chart('container', {
            chart: {
                zoomType: 'x'
            },
            title: {
                text: 'ZB网QC币OTC交易价格走势图'
            },
            subtitle: {
                text: document.ontouchstart === undefined ?
                    '鼠标拖动可以进行缩放' : '手势操作进行缩放'
            },
            xAxis: {
                type: 'datetime',
                dateTimeLabelFormats: {
                    millisecond: '%H:%M:%S.%L',
                    second: '%H:%M:%S',
                    minute: '%H:%M',
                    hour: '%H:%M',
                    day: '%m-%d',
                    week: '%m-%d',
                    month: '%Y-%m',
                    year: '%Y'
                }
            },
            tooltip: {
                dateTimeLabelFormats: {
                    millisecond: '%H:%M:%S.%L',
                    second: '%Y-%m-%d %H:%M:%S',
                    minute: '%H:%M',
                    hour: '%H:%M',
                    day: '%Y-%m-%d',
                    week: '%m-%d',
                    month: '%Y-%m',
                    year: '%Y'
                }
            },
            yAxis: {
                title: {
                    text: '价格(CNY)'
                }
            },
            legend: {
                enabled: false
            },
            plotOptions: {
                area: {
                    fillColor: {
                        linearGradient: {
                            x1: 0,
                            y1: 0,
                            x2: 0,
                            y2: 1
                        },
                        stops: [
                            [0, Highcharts.getOptions().colors[0]],
                            [1, Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]
                        ]
                    },
                    marker: {
                        radius: 2
                    },
                    lineWidth: 1,
                    states: {
                        hover: {
                            lineWidth: 1
                        }
                    },
                    threshold: null
                }
            },
            series: [{
                type: 'area',
                name: '价格',
                data: data.result
            }]
        });
    });
</script>