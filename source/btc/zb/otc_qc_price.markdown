---
layout: post
title: "zb.com QC币OTC价格趋势"
categories: [QC,BTC,zb.com,OTC,QC价格趋势]
---

<script src="https://cdn.hcharts.cn/highcharts/highcharts.js"></script>
<script src="https://cdn.hcharts.cn/highcharts-plugins/highcharts-zh_CN.js"></script>

> QC币全称为Qcash，是基于量子链智能合约的数字货币，由Qcash基金会发行的独立数字货币。

* 在[https://www.zb.com](https://www.zb.com)可以用于交易各种数字币种.
* 此价格图标数据为每小时从`zb.com`抓取,可用于投资者判断交易

<div id="container" style="width: 100%;height:400px;"></div>

以上价格通常代表着:

* 价格走低,说明套现离场情绪偏高
* 价格走高,索命积极入场情绪偏高

<script>
    var chart = null;
    $.getJSON('http://107.151.139.189:8888/zb/otc/qc/list', function (data) {
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