#!/usr/bin/env bash

# 压测脚本模板中设定的压测时间应为60秒
export jmx_template="iInterface"
export suffix=".jmx"
export jmx_template_filename="${jmx_template}${suffix}"
#通过获取文件类型来判断系统 从而控制操作类型
export os_type=`uname`

# 需要在系统变量中定义jmeter根目录的位置，如下
# export jmeter_path="/your jmeter path/"

echo "自动化压测开始"

# 压测并发数列表
thread_number_array=(10 20 30)
for num in "${thread_number_array[@]}"
do
    # 生成对应压测线程的jmx文件
    export jmx_filename="${jmx_template}_${num}${suffix}"
    #压测结果
    export jtl_filename="test_${num}.jtl"
    #测试报告
    export web_report_path_name="web_${num}"

    #删除已存在数据
    rm -f ${jmx_filename} ${jtl_filename}
    #删除路径下所有
    rm -rf ${web_report_path_name}

    #生成文件
    cp ${jmx_template_filename} ${jmx_filename}
    echo "生成jmx压测脚本 ${jmx_filename}"

    if [[ "${os_type}" == "Darwin" ]]; then
        sed -i "" "s/thread_num/${num}/g" ${jmx_filename}
    else
        sed -i "s/thread_num/${num}/g" ${jmx_filename}
    fi

    # JMeter 静默压测
    ${jmeter_path}/bin/jmeter -n -t ${jmx_filename} -l ${jtl_filename}

    # 生成Web压测报告
    ${jmeter_path}/bin/jmeter -g ${jtl_filename} -e -o ${web_report_path_name}

    # rm -f ${jmx_filename} ${jtl_filename}
done
echo "自动化压测全部结束"

