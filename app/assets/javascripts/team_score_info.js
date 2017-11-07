var myChart = echarts.init(document.getElementById('main'));

// 指定图表的配置项和数据
var option = {
        title: {
            text: '车站考试成绩分析'
        },
        tooltip : {
            trigger: 'axis',
            axisPointer : {            // 坐标轴指示器，坐标轴触发有效
                type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'

            }
        },
        legend: {
            data: ['90分以上', '80-90分','60-80分','60分以下']
        },
        grid: {
            left: '3%',
            right: '4%',
            y2:120,
            containLabel: true
        },
        yAxis:  {
            type: 'value'
        },
        xAxis: [{
            type: 'category',
            splitLine: {
              show: false
          },
          axisTick: {
              show: false
          },
          splitArea: {
              show: false
          },
          axisLabel: {
              interval: 0,
              show: true,
              splitNumber: 15,
              textStyle: {
                  fontFamily: "微软雅黑",
                  fontSize: 14
              }
            },
            data: gon.team_key
        }],
        series: [
            {
                name: '90分以上',
                type: 'bar',
                stack: '总分',
                label: {
                    normal: {
                        show: true,
                        position: 'insideRight'
                    }
                },
                data: gon.ninefen
            },
            {
                name: '80-90分',
                type: 'bar',
                stack: '总分',
                label: {
                    normal: {
                        show: true,
                        position: 'insideRight'
                    }
                },
                data: gon.ef
            },
            {
                name: '60-80分',
                type: 'bar',
                stack: '总分',
                label: {
                    normal: {
                        show: true,
                        position: 'insideRight'
                    }
                },
                data: gon.sf
            },
            {
                name: '60分以下',
                type: 'bar',
                stack: '总分',
                barWidth: 60,
                label: {
                    normal: {
                        show: true,
                        position: 'insideRight'
                    }
                },
                data: gon.sb
            }
        ]
    };


    // 使用刚指定的配置项和数据显示图表。
myChart.setOption(option);
<% if params[:search].present? %>
myChart.on('click', function (params) {
window.location.assign('<%= team_score_info_t_team_infoes_path('duan_name': params[:duan_name], 'station_name': params[:station_name], "utf8": params[:utf8], "search": params[:search], "commit": params[:commit])%>&team_name=' + params.name);
});
<% else %>
myChart.on('click', function (params) {
window.location.assign('/t_team_infoes/team_score_info?duan_name=<%= params[:duan_name]%>&station_name=<%= params[:station_name]%>&team_name=' + params.name);
});
<% end %>
