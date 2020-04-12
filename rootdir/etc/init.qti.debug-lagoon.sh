#!/vendor/bin/sh

#Copyright (c) 2020, The Linux Foundation. All rights reserved.
#
#Redistribution and use in source and binary forms, with or without
#modification, are permitted provided that the following conditions are met:
#    * Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above
#      copyright notice, this list of conditions and the following
#      disclaimer in the documentation and/or other materials provided
#      with the distribution.
#    * Neither the name of The Linux Foundation nor the names of its
#      contributors may be used to endorse or promote products derived
#      from this software without specific prior written permission.
#
#THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
#WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
#MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
#ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
#BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
#CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
#SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
#BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
#WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
#OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
#IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

enable_tracing_events_lagoon()
{
    # timer
    echo 1 > /sys/kernel/debug/tracing/events/timer/timer_expire_entry/enable
    echo 1 > /sys/kernel/debug/tracing/events/timer/timer_expire_exit/enable
    #echo 1 > /sys/kernel/debug/tracing/events/timer/hrtimer_cancel/enable
    echo 1 > /sys/kernel/debug/tracing/events/timer/hrtimer_expire_entry/enable
    echo 1 > /sys/kernel/debug/tracing/events/timer/hrtimer_expire_exit/enable
    #echo 1 > /sys/kernel/debug/tracing/events/timer/hrtimer_init/enable
    #echo 1 > /sys/kernel/debug/tracing/events/timer/hrtimer_start/enable
    #enble FTRACE for softirq events
    echo 1 > /sys/kernel/debug/tracing/events/irq/enable
    #enble FTRACE for Workqueue events
    echo 1 > /sys/kernel/debug/tracing/events/workqueue/enable
    # schedular
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_cpu_hotplug/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_migrate_task/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_pi_setprio/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_switch/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_wakeup/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_wakeup_new/enable
    echo 1 > /sys/kernel/debug/tracing/events/sched/sched_isolate/enable
    # video
    echo 1 > /sys/kernel/debug/tracing/events/msm_vidc_events/enable
    # clock
    echo 1 > /sys/kernel/debug/tracing/events/power/clock_set_rate/enable
    echo 1 > /sys/kernel/debug/tracing/events/power/clock_enable/enable
    echo 1 > /sys/kernel/debug/tracing/events/power/clock_disable/enable
    echo 1 > /sys/kernel/debug/tracing/events/power/cpu_frequency/enable
    # regulator
    echo 1 > /sys/kernel/debug/tracing/events/regulator/enable
    # power
    #echo 1 > /sys/kernel/debug/tracing/events/msm_low_power/enable
    echo 1 > /sys/kernel/debug/tracing/events/msm_low_power/cpu_idle_enter/enable
    echo 1 > /sys/kernel/debug/tracing/events/msm_low_power/cpu_idle_exit/enable
    #thermal
    echo 1 > /sys/kernel/debug/tracing/events/thermal/enable
    #scm
    echo 1 > /sys/kernel/debug/tracing/events/scm/enable
    #rmph_send_msg
    echo 1 > /sys/kernel/debug/tracing/events/rpmh/rpmh_send_msg/enable

    #enable aop with timestamps
    # echo 33 0x680000 > /sys/bus/coresight/devices/coresight-tpdm-swao-0/cmb_msr
    # echo 48 0xC0 > /sys/bus/coresight/devices/coresight-tpdm-swao-0/cmb_msr
    # echo 0x4 > /sys/bus/coresight/devices/coresight-tpdm-swao-0/mcmb_lanes_select
    # echo 1 0 > /sys/bus/coresight/devices/coresight-tpdm-swao-0/cmb_mode
    # echo 1 > /sys/bus/coresight/devices/coresight-tpdm-swao-0/cmb_trig_ts
    # echo 1 >  /sys/bus/coresight/devices/coresight-tpdm-swao-0/enable_source
    # echo 4 2 > /sys/bus/coresight/devices/coresight-cti-swao_cti0/map_trigin
    # echo 4 2 > /sys/bus/coresight/devices/coresight-cti-swao_cti0/map_trigout

    #memory pressure events/oom
    echo 1 > /sys/kernel/debug/tracing/events/psi/psi_event/enable
    echo 1 > /sys/kernel/debug/tracing/events/psi/psi_window_vmstat/enable

    #iommu events
    echo 1 > /sys/kernel/debug/tracing/events/iommu/map/enable
    echo 1 > /sys/kernel/debug/tracing/events/iommu/map_sg/enable
    echo 1 > /sys/kernel/debug/tracing/events/iommu/unmap/enable

    echo 1 > /sys/kernel/debug/tracing/tracing_on
}

# function to enable ftrace events
enable_ftrace_event_tracing_lagoon()
{
    # bail out if its perf config
    if [ ! -d /sys/module/msm_rtb ]
    then
        return
    fi

    # bail out if ftrace events aren't present
    if [ ! -d /sys/kernel/debug/tracing/events ]
    then
        return
    fi

    enable_tracing_events_lagoon
}

# function to enable ftrace event transfer to CoreSight STM
enable_stm_events_lagoon()
{
    # bail out if its perf config
    if [ ! -d /sys/module/msm_rtb ]
    then
        return
    fi
    # bail out if coresight isn't present
    if [ ! -d /sys/bus/coresight ]
    then
        return
    fi
    # bail out if ftrace events aren't present
    if [ ! -d /sys/kernel/debug/tracing/events ]
    then
        return
    fi

    echo $etr_size > /sys/bus/coresight/devices/coresight-tmc-etr/buffer_size
    echo 1 > /sys/bus/coresight/devices/coresight-tmc-etr/$sinkenable
    echo 1 > /sys/bus/coresight/devices/coresight-stm/$srcenable
    echo 1 > /sys/kernel/debug/tracing/tracing_on
    echo 0 > /sys/bus/coresight/devices/coresight-stm/hwevent_enable
    enable_tracing_events_lagoon
}

config_lagoon_dcc_ddr()
{
    #DDR - DCC starts here.
    #Start Link list #4
    #LLCC
    echo 0x9220480 > $DCC_PATH/config
    echo 0x9232100 > $DCC_PATH/config
    echo 0x92360b0 > $DCC_PATH/config
    echo 0x9236044 > $DCC_PATH/config
    echo 0x9236048 > $DCC_PATH/config
    echo 0x923604C > $DCC_PATH/config
    echo 0x9236050 > $DCC_PATH/config
    echo 0x923e030 > $DCC_PATH/config
    echo 0x9241000 > $DCC_PATH/config
    echo 0x9248048 > $DCC_PATH/config
    echo 0x9248058 > $DCC_PATH/config
    echo 0x924805C > $DCC_PATH/config
    echo 0x9248060 > $DCC_PATH/config
    echo 0x9248064 > $DCC_PATH/config
    echo 0x9222408 > $DCC_PATH/config
    echo 0x9220344 > $DCC_PATH/config
    echo 0x9220348 > $DCC_PATH/config
    echo 0x922358C > $DCC_PATH/config
    echo 0x9222398 > $DCC_PATH/config
    echo 0x92223A4 > $DCC_PATH/config
    echo 0x923201C > $DCC_PATH/config
    echo 0x9232020 > $DCC_PATH/config
    echo 0x9232024 > $DCC_PATH/config
    echo 0x9232028 > $DCC_PATH/config
    echo 0x923202C > $DCC_PATH/config
    echo 0x9232050 > $DCC_PATH/config
    echo 0x9236028 > $DCC_PATH/config
    echo 0x923602C > $DCC_PATH/config
    echo 0x9236030 > $DCC_PATH/config
    echo 0x9236034 > $DCC_PATH/config
    echo 0x9236038 > $DCC_PATH/config
    echo 0x9236040 > $DCC_PATH/config
    echo 0x9236054 > $DCC_PATH/config
    echo 0x9236060 > $DCC_PATH/config

    #CABO
    echo 0x9260400 > $DCC_PATH/config
    echo 0x9260410 > $DCC_PATH/config
    echo 0x9260414 > $DCC_PATH/config
    echo 0x9260418 > $DCC_PATH/config
    echo 0x9260420 > $DCC_PATH/config
    echo 0x9260424 > $DCC_PATH/config
    echo 0x9260430 > $DCC_PATH/config
    echo 0x9260440 > $DCC_PATH/config
    echo 0x9260448 > $DCC_PATH/config
    echo 0x92604a0 > $DCC_PATH/config
    echo 0x92604B8 > $DCC_PATH/config
    echo 0x9265804 > $DCC_PATH/config
    echo 0x9266418 > $DCC_PATH/config
    echo 0x92E0400 > $DCC_PATH/config
    echo 0x92e0410 > $DCC_PATH/config
    echo 0x92e0414 > $DCC_PATH/config
    echo 0x92e0418 > $DCC_PATH/config
    echo 0x92e0420 > $DCC_PATH/config
    echo 0x92e0424 > $DCC_PATH/config
    echo 0x92e0430 > $DCC_PATH/config
    echo 0x92e0440 > $DCC_PATH/config
    echo 0x92e0448 > $DCC_PATH/config
    echo 0x92e04a0 > $DCC_PATH/config
    echo 0x92E04B8 > $DCC_PATH/config
    echo 0x92E5804 > $DCC_PATH/config
    echo 0x92E6418 > $DCC_PATH/config
    echo 0x92E5B1C > $DCC_PATH/config
    echo 0x92E6420 > $DCC_PATH/config
    echo 0x92E04D4 > $DCC_PATH/config
    echo 0x92604B0 > $DCC_PATH/config
    echo 0x92E0404 > $DCC_PATH/config
    echo 0x92E04B0 > $DCC_PATH/config
    echo 0x92E04D0 > $DCC_PATH/config
    echo 0x9260404 > $DCC_PATH/config
    echo 0x9265840 > $DCC_PATH/config
    echo 0x9265B18 > $DCC_PATH/config

    #LLCC Broadcast
    echo 0x9600000 > $DCC_PATH/config
    echo 0x9600004 > $DCC_PATH/config
    echo 0x9601000 > $DCC_PATH/config
    echo 0x9601004 > $DCC_PATH/config
    echo 0x9602000 > $DCC_PATH/config
    echo 0x9602004 > $DCC_PATH/config
    echo 0x9603000 > $DCC_PATH/config
    echo 0x9603004 > $DCC_PATH/config
    echo 0x9604000 > $DCC_PATH/config
    echo 0x9604004 > $DCC_PATH/config
    echo 0x9605000 > $DCC_PATH/config
    echo 0x9605004 > $DCC_PATH/config
    echo 0x9606000 > $DCC_PATH/config
    echo 0x9606004 > $DCC_PATH/config
    echo 0x9607000 > $DCC_PATH/config
    echo 0x9607004 > $DCC_PATH/config
    echo 0x9608000 > $DCC_PATH/config
    echo 0x9608004 > $DCC_PATH/config
    echo 0x9609000 > $DCC_PATH/config
    echo 0x9609004 > $DCC_PATH/config
    echo 0x960a000 > $DCC_PATH/config
    echo 0x960a004 > $DCC_PATH/config
    echo 0x960b000 > $DCC_PATH/config
    echo 0x960b004 > $DCC_PATH/config
    echo 0x960c000 > $DCC_PATH/config
    echo 0x960c004 > $DCC_PATH/config
    echo 0x960d000 > $DCC_PATH/config
    echo 0x960d004 > $DCC_PATH/config
    echo 0x960e000 > $DCC_PATH/config
    echo 0x960e004 > $DCC_PATH/config
    echo 0x960f000 > $DCC_PATH/config
    echo 0x960f004 > $DCC_PATH/config
    echo 0x9610000 > $DCC_PATH/config
    echo 0x9610004 > $DCC_PATH/config
    echo 0x9611000 > $DCC_PATH/config
    echo 0x9611004 > $DCC_PATH/config
    echo 0x9612000 > $DCC_PATH/config
    echo 0x9612004 > $DCC_PATH/config
    echo 0x9613000 > $DCC_PATH/config
    echo 0x9613004 > $DCC_PATH/config
    echo 0x9614000 > $DCC_PATH/config
    echo 0x9614004 > $DCC_PATH/config
    echo 0x9615000 > $DCC_PATH/config
    echo 0x9615004 > $DCC_PATH/config
    echo 0x9616000 > $DCC_PATH/config
    echo 0x9616004 > $DCC_PATH/config
    echo 0x9617000 > $DCC_PATH/config
    echo 0x9617004 > $DCC_PATH/config
    echo 0x9618000 > $DCC_PATH/config
    echo 0x9618004 > $DCC_PATH/config
    echo 0x9619000 > $DCC_PATH/config
    echo 0x9619004 > $DCC_PATH/config
    echo 0x961a000 > $DCC_PATH/config
    echo 0x961a004 > $DCC_PATH/config
    echo 0x961b000 > $DCC_PATH/config
    echo 0x961b004 > $DCC_PATH/config
    echo 0x961c000 > $DCC_PATH/config
    echo 0x961c004 > $DCC_PATH/config
    echo 0x961d000 > $DCC_PATH/config
    echo 0x961d004 > $DCC_PATH/config
    echo 0x961e000 > $DCC_PATH/config
    echo 0x961e004 > $DCC_PATH/config
    echo 0x961f000 > $DCC_PATH/config
    echo 0x961f004 > $DCC_PATH/config

    #SHRM
    echo 0x9050008 > $DCC_PATH/config
    echo 0x9050068 > $DCC_PATH/config
    echo 0x9050078 > $DCC_PATH/config

    #MCCC
    echo 0x90b0280 > $DCC_PATH/config
    echo 0x90b0288 > $DCC_PATH/config
    echo 0x90b028c > $DCC_PATH/config
    echo 0x90b0290 > $DCC_PATH/config
    echo 0x90b0294 > $DCC_PATH/config
    echo 0x90b0298 > $DCC_PATH/config
    echo 0x90b029c > $DCC_PATH/config
    echo 0x90b02a0 > $DCC_PATH/config
    echo 0x90B0004 > $DCC_PATH/config
    echo 0x90C012C > $DCC_PATH/config
    echo 0x90C8040 > $DCC_PATH/config
    echo 0x9186048 > $DCC_PATH/config
    echo 0x9186054 > $DCC_PATH/config
    echo 0x9186164 > $DCC_PATH/config
    echo 0x9186170 > $DCC_PATH/config
    echo 0x9186078 > $DCC_PATH/config
    echo 0x9186264 > $DCC_PATH/config
    echo 0x9250110 > $DCC_PATH/config
    echo 0x9223318 > $DCC_PATH/config

   #End Link list #4
}

config_lagoon_dcc_cam()
{
    #Cam CC
    echo 0x10B008 > $DCC_PATH/config
    echo 0xAD0C1C4 > $DCC_PATH/config
    echo 0xAD0C12C > $DCC_PATH/config
    echo 0xAD0C130 > $DCC_PATH/config
    echo 0xAD0C144 > $DCC_PATH/config
    echo 0xAD0C148 > $DCC_PATH/config
}

config_lagoon_dcc_gemnoc()
{
    #GemNOC for lagoon start
    echo 0x9680000 3 > $DCC_PATH/config
    echo 8 > $DCC_PATH/loop
    echo 0x9681000 3 > $DCC_PATH/config
    echo 1 > $DCC_PATH/loop
    echo 0x09680078 > $DCC_PATH/config
    echo 0x9681008 12> $DCC_PATH/config
    echo 0xA6 > $DCC_PATH/loop
    echo 0x9681008 > $DCC_PATH/config
    echo 0x968100C > $DCC_PATH/config
    echo 1 > $DCC_PATH/loop
    echo 0x968103C > $DCC_PATH/config
    echo 0x9698100 > $DCC_PATH/config
    echo 0x9698104 > $DCC_PATH/config
    echo 0x9698108 > $DCC_PATH/config
    echo 0x9698110 > $DCC_PATH/config
    echo 0x9698120 > $DCC_PATH/config
    echo 0x9698124 > $DCC_PATH/config
    echo 0x9698128 > $DCC_PATH/config
    echo 0x969812c > $DCC_PATH/config
    echo 0x9698130 > $DCC_PATH/config
    echo 0x9698134 > $DCC_PATH/config
    echo 0x9698138 > $DCC_PATH/config
    echo 0x969813c > $DCC_PATH/config
    #GemNOC for lagoon end
}

config_lagoon_dcc_gpu()
{
    #GPUCC
    echo 0x3D9106C > $DCC_PATH/config
    echo 0x3D9100C > $DCC_PATH/config
    echo 0x3D91010 > $DCC_PATH/config
    echo 0x3D91014 > $DCC_PATH/config
    echo 0x3D91070 > $DCC_PATH/config
    echo 0x3D91074 > $DCC_PATH/config
    echo 0x3D91098 > $DCC_PATH/config
    echo 0x3D91004 > $DCC_PATH/config
    echo 0x3D9109C > $DCC_PATH/config
    echo 0x3D91078 > $DCC_PATH/config
    echo 0x3D91054 > $DCC_PATH/config
}

config_lagoon_dcc_lpm()
{
    #PCU Register
    echo 0x18000024 > $DCC_PATH/config
    echo 0x18000040 > $DCC_PATH/config
    echo 0x18010024 > $DCC_PATH/config
    echo 0x18010040 > $DCC_PATH/config
    echo 0x18020024 > $DCC_PATH/config
    echo 0x18020040 > $DCC_PATH/config
    echo 0x18030024 > $DCC_PATH/config
    echo 0x18030040 > $DCC_PATH/config
    echo 0x18040024 > $DCC_PATH/config
    echo 0x18040040 > $DCC_PATH/config
    echo 0x18050024 > $DCC_PATH/config
    echo 0x18050040 > $DCC_PATH/config
    echo 0x18060024 > $DCC_PATH/config
    echo 0x18060040 > $DCC_PATH/config
    echo 0x18070024 > $DCC_PATH/config
    echo 0x18070040 > $DCC_PATH/config
    echo 0x18080024 > $DCC_PATH/config
    echo 0x18080040 > $DCC_PATH/config
    echo 0x18080044 > $DCC_PATH/config
    echo 0x18080048 > $DCC_PATH/config
    echo 0x1808004c > $DCC_PATH/config
    echo 0x18080054 > $DCC_PATH/config
    echo 0x1808006c > $DCC_PATH/config
    echo 0x18080070 > $DCC_PATH/config
    echo 0x18080074 > $DCC_PATH/config
    echo 0x18080078 > $DCC_PATH/config
    echo 0x1808007c > $DCC_PATH/config
    echo 0x180800f4 > $DCC_PATH/config
    echo 0x180800f8 > $DCC_PATH/config
    echo 0x18080104 > $DCC_PATH/config
    echo 0x18080118 > $DCC_PATH/config
    echo 0x1808011c > $DCC_PATH/config
    echo 0x18080128 > $DCC_PATH/config
    echo 0x1808012c > $DCC_PATH/config
    echo 0x18080130 > $DCC_PATH/config
    echo 0x18080134 > $DCC_PATH/config
    echo 0x18080138 > $DCC_PATH/config
    echo 0x180801b4 > $DCC_PATH/config
    echo 0x180801b8 > $DCC_PATH/config
    echo 0x180801bc > $DCC_PATH/config
    echo 0x180801f0 > $DCC_PATH/config
    echo 0x18280000 > $DCC_PATH/config
    echo 0x18282000 > $DCC_PATH/config
    echo 0x18284000 > $DCC_PATH/config
}

config_lagoon_dcc_osm()
{
    #APSS_OSM_RAIN0/RAIL1
    echo 0x1832102c > $DCC_PATH/config
    echo 0x18321044 > $DCC_PATH/config
    echo 0x18321700 > $DCC_PATH/config
    echo 0x18321710 > $DCC_PATH/config
    echo 0x1832176c > $DCC_PATH/config
    echo 0x18321818 > $DCC_PATH/config
    echo 0x1832181C > $DCC_PATH/config
    echo 0x18321824 > $DCC_PATH/config
    echo 0x18321920 > $DCC_PATH/config
    echo 0x18322C14 > $DCC_PATH/config
    echo 0x18322c18 > $DCC_PATH/config
    echo 0x1832302c > $DCC_PATH/config
    echo 0x18323044 > $DCC_PATH/config
    echo 0x18323710 > $DCC_PATH/config
    echo 0x1832376c > $DCC_PATH/config
    echo 0x18323818 > $DCC_PATH/config
    echo 0x1832381C > $DCC_PATH/config
    echo 0x18323824 > $DCC_PATH/config
    echo 0x18323920 > $DCC_PATH/config
    echo 0x18324c18 > $DCC_PATH/config
    echo 0x1832582c > $DCC_PATH/config
    echo 0x18325844 > $DCC_PATH/config
    echo 0x18325f10 > $DCC_PATH/config
    echo 0x18325f6c > $DCC_PATH/config
    echo 0x18326018 > $DCC_PATH/config
    echo 0x1832601C > $DCC_PATH/config
    echo 0x18326024 > $DCC_PATH/config
    echo 0x18326120 > $DCC_PATH/config
    echo 0x18327414 > $DCC_PATH/config
    echo 0x18327418 > $DCC_PATH/config
    echo 0x1837103C > $DCC_PATH/config
    echo 0x18371034 > $DCC_PATH/config
    echo 0x18371810 > $DCC_PATH/config
    echo 0x18371814 > $DCC_PATH/config
    echo 0x18200040 > $DCC_PATH/config
    echo 0x18371820 > $DCC_PATH/config
    echo 0x18325F04 > $DCC_PATH/config
    echo 0x18325F00 > $DCC_PATH/config
    echo 0x18325F2C > $DCC_PATH/config
    echo 0x1837903C > $DCC_PATH/config
    echo 0x18379034 > $DCC_PATH/config
    echo 0x18379810 > $DCC_PATH/config
    echo 0x18379814 > $DCC_PATH/config
    echo 0x1837981C > $DCC_PATH/config
    echo 0x18379820 > $DCC_PATH/config
    echo 0x18323700 > $DCC_PATH/config
    echo 0x18323704 > $DCC_PATH/config
    echo 0x1832372C > $DCC_PATH/config
}

config_lagoon_dcc_core()
{
    # core hang
    echo 0x1800005C 1 > $DCC_PATH/config
    echo 0x1801005C 1 > $DCC_PATH/config
    echo 0x1802005C 1 > $DCC_PATH/config
    echo 0x1803005C 1 > $DCC_PATH/config
    echo 0x1804005C 1 > $DCC_PATH/config
    echo 0x1805005C 1 > $DCC_PATH/config
    echo 0x1806005C 1 > $DCC_PATH/config
    echo 0x1807005C 1 > $DCC_PATH/config
    echo 0x17C0003C 1 > $DCC_PATH/config

    #CPRh
    echo 0x18101908 1 > $DCC_PATH/config
    echo 0x18101C18 1 > $DCC_PATH/config
    echo 0x18390810 1 > $DCC_PATH/config
    echo 0x18390814 1 > $DCC_PATH/config
    echo 0x18390818 1 > $DCC_PATH/config
    echo 0x18393A84 1 > $DCC_PATH/config
    echo 0x18100908 1 > $DCC_PATH/config
    echo 0x18100C18 1 > $DCC_PATH/config
    echo 0x183A0810 1 > $DCC_PATH/config
    echo 0x183A0814 1 > $DCC_PATH/config
    echo 0x183A0818 1 > $DCC_PATH/config
    echo 0x183A3A84 2 > $DCC_PATH/config
    echo 0x18393500 1 > $DCC_PATH/config
    echo 0x183A3500 1 > $DCC_PATH/config

    #Silver / L3 / Gold PLL
    echo 0x18280000 4 > $DCC_PATH/config
    echo 0x18284000 4 > $DCC_PATH/config

    #Gold PLL
    echo 0x18280084 > $DCC_PATH/config
    echo 0x18282000 4 > $DCC_PATH/config
    echo 0x18282028 1 > $DCC_PATH/config
    echo 0x18282038 1 > $DCC_PATH/config
    echo 0x18282080 5 > $DCC_PATH/config

    #rpmh
    echo 0x0C201244 1 > $DCC_PATH/config
    echo 0x0C202244 1 > $DCC_PATH/config
    echo 0x18300000 1 > $DCC_PATH/config

    #GOLD
    echo 0x1829208C 1 > $DCC_PATH/config
    echo 0x1829209C 0x78 > $DCC_PATH/config_write
    echo 0x1829209C 0x0  > $DCC_PATH/config_write
    echo 0x18292048 0x1  > $DCC_PATH/config_write
    echo 0x18292090 0x0  > $DCC_PATH/config_write
    echo 0x18292090 0x25 > $DCC_PATH/config_write
    echo 0x18292098 1 > $DCC_PATH/config
    echo 0x18292048 0x1D > $DCC_PATH/config_write
    echo 0x18292090 0x0  > $DCC_PATH/config_write
    echo 0x18292090 0x25 > $DCC_PATH/config_write
    echo 0x18292098 1 > $DCC_PATH/config

}
config_lagoon_dcc_rsc_tcs()
{
    #APPS RSC TCS
    echo 0x18220d10 > $DCC_PATH/config
    echo 0x18220d14 > $DCC_PATH/config
    echo 0x18200d1c > $DCC_PATH/config
    echo 0x18200d34 > $DCC_PATH/config
    echo 0x18200d38 > $DCC_PATH/config
    echo 0x18200d3c > $DCC_PATH/config
    echo 0x18200d48 > $DCC_PATH/config
    echo 0x18200d4c > $DCC_PATH/config
    echo 0x18200d50 > $DCC_PATH/config

    echo 0x18220fb4 > $DCC_PATH/config
    echo 0x18221254 > $DCC_PATH/config
    echo 0x182214f4 > $DCC_PATH/config
    echo 0x18221794 > $DCC_PATH/config
    echo 0x18221a34 > $DCC_PATH/config
    echo 0x18221cd4 > $DCC_PATH/config
    echo 0x18221f74 > $DCC_PATH/config
    echo 0x18220d18 > $DCC_PATH/config
    echo 0x18220fb8 > $DCC_PATH/config
    echo 0x18221258 > $DCC_PATH/config
    echo 0x182214f8 > $DCC_PATH/config
    echo 0x18221798 > $DCC_PATH/config
    echo 0x18221a38 > $DCC_PATH/config
    echo 0x18221cd8 > $DCC_PATH/config
    echo 0x18221f78 > $DCC_PATH/config
    echo 0x18220d00 > $DCC_PATH/config
    echo 0x18220d04 > $DCC_PATH/config
    echo 0x18220d1c > $DCC_PATH/config
    echo 0x18220fbc > $DCC_PATH/config
    echo 0x1822125c > $DCC_PATH/config
    echo 0x182214fc > $DCC_PATH/config
    echo 0x1822179c > $DCC_PATH/config
    echo 0x18221a3c > $DCC_PATH/config
    echo 0x18221cdc > $DCC_PATH/config
    echo 0x18221f7c > $DCC_PATH/config
    echo 0x18221274 > $DCC_PATH/config
    echo 0x18221288 > $DCC_PATH/config
    echo 0x1822129c > $DCC_PATH/config
    echo 0x182212b0 > $DCC_PATH/config
    echo 0x182212c4 > $DCC_PATH/config
    echo 0x182212d8 > $DCC_PATH/config
    echo 0x182212ec > $DCC_PATH/config
    echo 0x18221300 > $DCC_PATH/config
    echo 0x18221314 > $DCC_PATH/config
    echo 0x18221328 > $DCC_PATH/config
    echo 0x1822133c > $DCC_PATH/config
    echo 0x18221350 > $DCC_PATH/config
    echo 0x18221364 > $DCC_PATH/config
    echo 0x18221378 > $DCC_PATH/config
    echo 0x1822138c > $DCC_PATH/config
    echo 0x182213a0 > $DCC_PATH/config
    echo 0x18221514 > $DCC_PATH/config
    echo 0x18221528 > $DCC_PATH/config
    echo 0x1822153c > $DCC_PATH/config
    echo 0x18221550 > $DCC_PATH/config
    echo 0x18221564 > $DCC_PATH/config
    echo 0x18221578 > $DCC_PATH/config
    echo 0x1822158c > $DCC_PATH/config
    echo 0x182215a0 > $DCC_PATH/config
    echo 0x182215b4 > $DCC_PATH/config
    echo 0x182215c8 > $DCC_PATH/config
    echo 0x182215dc > $DCC_PATH/config
    echo 0x182215f0 > $DCC_PATH/config
    echo 0x18221604 > $DCC_PATH/config
    echo 0x18221618 > $DCC_PATH/config
    echo 0x1822162c > $DCC_PATH/config
    echo 0x18221640 > $DCC_PATH/config
    echo 0x182217b4 > $DCC_PATH/config
    echo 0x182217c8 > $DCC_PATH/config
    echo 0x182217dc > $DCC_PATH/config
    echo 0x182217f0 > $DCC_PATH/config
    echo 0x18221804 > $DCC_PATH/config
    echo 0x18221818 > $DCC_PATH/config
    echo 0x1822182c > $DCC_PATH/config
    echo 0x18221840 > $DCC_PATH/config
    echo 0x18221854 > $DCC_PATH/config
    echo 0x18221868 > $DCC_PATH/config
    echo 0x1822187c > $DCC_PATH/config
    echo 0x18221890 > $DCC_PATH/config
    echo 0x182218a4 > $DCC_PATH/config
    echo 0x182218b8 > $DCC_PATH/config
    echo 0x182218cc > $DCC_PATH/config
    echo 0x182218e0 > $DCC_PATH/config
    echo 0x18221a54 > $DCC_PATH/config
    echo 0x18221a68 > $DCC_PATH/config
    echo 0x18221a7c > $DCC_PATH/config
    echo 0x18221a90 > $DCC_PATH/config
    echo 0x18221aa4 > $DCC_PATH/config
    echo 0x18221ab8 > $DCC_PATH/config
    echo 0x18221acc > $DCC_PATH/config
    echo 0x18221ae0 > $DCC_PATH/config
    echo 0x18221af4 > $DCC_PATH/config
    echo 0x18221b08 > $DCC_PATH/config
    echo 0x18221b1c > $DCC_PATH/config
    echo 0x18221b30 > $DCC_PATH/config
    echo 0x18221b44 > $DCC_PATH/config
    echo 0x18221b58 > $DCC_PATH/config
    echo 0x18221b6c > $DCC_PATH/config
    echo 0x18221b80 > $DCC_PATH/config
    echo 0x18221cf4 > $DCC_PATH/config
    echo 0x18221d08 > $DCC_PATH/config
    echo 0x18221d1c > $DCC_PATH/config
    echo 0x18221d30 > $DCC_PATH/config
    echo 0x18221d44 > $DCC_PATH/config
    echo 0x18221d58 > $DCC_PATH/config
    echo 0x18221d6c > $DCC_PATH/config
    echo 0x18221d80 > $DCC_PATH/config
    echo 0x18221d94 > $DCC_PATH/config
    echo 0x18221da8 > $DCC_PATH/config
    echo 0x18221dbc > $DCC_PATH/config
    echo 0x18221dd0 > $DCC_PATH/config
    echo 0x18221de4 > $DCC_PATH/config
    echo 0x18221df8 > $DCC_PATH/config
    echo 0x18221e0c > $DCC_PATH/config
    echo 0x18221e20 > $DCC_PATH/config
    echo 0x18221f94 > $DCC_PATH/config
    echo 0x18221fa8 > $DCC_PATH/config
    echo 0x18221fbc > $DCC_PATH/config
    echo 0x18221fd0 > $DCC_PATH/config
    echo 0x18221fe4 > $DCC_PATH/config
    echo 0x18221ff8 > $DCC_PATH/config
    echo 0x1822200c > $DCC_PATH/config
    echo 0x18222020 > $DCC_PATH/config
    echo 0x18222034 > $DCC_PATH/config
    echo 0x18222048 > $DCC_PATH/config
    echo 0x1822205c > $DCC_PATH/config
    echo 0x18222070 > $DCC_PATH/config
    echo 0x18222084 > $DCC_PATH/config
    echo 0x18222098 > $DCC_PATH/config
    echo 0x182220ac > $DCC_PATH/config
    echo 0x182220c0 > $DCC_PATH/config
    echo 0x18221278 > $DCC_PATH/config
    echo 0x1822128c > $DCC_PATH/config
    echo 0x182212a0 > $DCC_PATH/config
    echo 0x182212b4 > $DCC_PATH/config
    echo 0x182212c8 > $DCC_PATH/config
    echo 0x182212dc > $DCC_PATH/config
    echo 0x182212f0 > $DCC_PATH/config
    echo 0x18221304 > $DCC_PATH/config
    echo 0x18221318 > $DCC_PATH/config
    echo 0x1822132c > $DCC_PATH/config
    echo 0x18221340 > $DCC_PATH/config
    echo 0x18221354 > $DCC_PATH/config
    echo 0x18221368 > $DCC_PATH/config
    echo 0x1822137c > $DCC_PATH/config
    echo 0x18221390 > $DCC_PATH/config
    echo 0x182213a4 > $DCC_PATH/config
    echo 0x18221518 > $DCC_PATH/config
    echo 0x1822152c > $DCC_PATH/config
    echo 0x18221540 > $DCC_PATH/config
    echo 0x18221554 > $DCC_PATH/config
    echo 0x18221568 > $DCC_PATH/config
    echo 0x1822157c > $DCC_PATH/config
    echo 0x18221590 > $DCC_PATH/config
    echo 0x182215a4 > $DCC_PATH/config
    echo 0x182215b8 > $DCC_PATH/config
    echo 0x182215cc > $DCC_PATH/config
    echo 0x182215e0 > $DCC_PATH/config
    echo 0x182215f4 > $DCC_PATH/config
    echo 0x18221608 > $DCC_PATH/config
    echo 0x1822161c > $DCC_PATH/config
    echo 0x18221630 > $DCC_PATH/config
    echo 0x18221644 > $DCC_PATH/config
    echo 0x182217b8 > $DCC_PATH/config
    echo 0x182217cc > $DCC_PATH/config
    echo 0x182217e0 > $DCC_PATH/config
    echo 0x182217f4 > $DCC_PATH/config
    echo 0x18221808 > $DCC_PATH/config
    echo 0x1822181c > $DCC_PATH/config
    echo 0x18221830 > $DCC_PATH/config
    echo 0x18221844 > $DCC_PATH/config
    echo 0x18221858 > $DCC_PATH/config
    echo 0x1822186c > $DCC_PATH/config
    echo 0x18221880 > $DCC_PATH/config
    echo 0x18221894 > $DCC_PATH/config
    echo 0x182218a8 > $DCC_PATH/config
    echo 0x182218bc > $DCC_PATH/config
    echo 0x182218d0 > $DCC_PATH/config
    echo 0x182218e4 > $DCC_PATH/config
    echo 0x18221a58 > $DCC_PATH/config
    echo 0x18221a6c > $DCC_PATH/config
    echo 0x18221a80 > $DCC_PATH/config
    echo 0x18221a94 > $DCC_PATH/config
    echo 0x18221aa8 > $DCC_PATH/config
    echo 0x18221abc > $DCC_PATH/config
    echo 0x18221ad0 > $DCC_PATH/config
    echo 0x18221ae4 > $DCC_PATH/config
    echo 0x18221af8 > $DCC_PATH/config
    echo 0x18221b0c > $DCC_PATH/config
    echo 0x18221b20 > $DCC_PATH/config
    echo 0x18221b34 > $DCC_PATH/config
    echo 0x18221b48 > $DCC_PATH/config
    echo 0x18221b5c > $DCC_PATH/config
    echo 0x18221b70 > $DCC_PATH/config
    echo 0x18221b84 > $DCC_PATH/config
    echo 0x18221cf8 > $DCC_PATH/config
    echo 0x18221d0c > $DCC_PATH/config
    echo 0x18221d20 > $DCC_PATH/config
    echo 0x18221d34 > $DCC_PATH/config
    echo 0x18221d48 > $DCC_PATH/config
    echo 0x18221d5c > $DCC_PATH/config
    echo 0x18221d70 > $DCC_PATH/config
    echo 0x18221d84 > $DCC_PATH/config
    echo 0x18221d98 > $DCC_PATH/config
    echo 0x18221dac > $DCC_PATH/config
    echo 0x18221dc0 > $DCC_PATH/config
    echo 0x18221dd4 > $DCC_PATH/config
    echo 0x18221de8 > $DCC_PATH/config
    echo 0x18221dfc > $DCC_PATH/config
    echo 0x18221e10 > $DCC_PATH/config
    echo 0x18221e24 > $DCC_PATH/config
    echo 0x18221f98 > $DCC_PATH/config
    echo 0x18221fac > $DCC_PATH/config
    echo 0x18221fc0 > $DCC_PATH/config
    echo 0x18221fd4 > $DCC_PATH/config
    echo 0x18221fe8 > $DCC_PATH/config
    echo 0x18221ffc > $DCC_PATH/config
    echo 0x18222010 > $DCC_PATH/config
    echo 0x18222024 > $DCC_PATH/config
    echo 0x18222038 > $DCC_PATH/config
    echo 0x1822204c > $DCC_PATH/config
    echo 0x18222060 > $DCC_PATH/config
    echo 0x18222074 > $DCC_PATH/config
    echo 0x18222088 > $DCC_PATH/config
    echo 0x1822209c > $DCC_PATH/config
    echo 0x182220b0 > $DCC_PATH/config
    echo 0x182220c4 > $DCC_PATH/config

    #NPU RSC
    echo 0x98B0010 > $DCC_PATH/config
    echo 0x98B0014 > $DCC_PATH/config
    echo 0x98B0018 > $DCC_PATH/config
    echo 0x98B0210 > $DCC_PATH/config
    echo 0x98B0230 > $DCC_PATH/config
    echo 0x98B0250 > $DCC_PATH/config
    echo 0x98B0270 > $DCC_PATH/config
    echo 0x98B0290 > $DCC_PATH/config
    echo 0x98B02B0 > $DCC_PATH/config
    echo 0x98B0208 > $DCC_PATH/config
    echo 0x98B0228 > $DCC_PATH/config
    echo 0x98B0248 > $DCC_PATH/config
    echo 0x98B0268 > $DCC_PATH/config
    echo 0x98B0288 > $DCC_PATH/config
    echo 0x98B02A8 > $DCC_PATH/config
    echo 0x98B020C > $DCC_PATH/config
    echo 0x98B022C > $DCC_PATH/config
    echo 0x98B024C > $DCC_PATH/config
    echo 0x98B026C > $DCC_PATH/config
    echo 0x98B028C > $DCC_PATH/config
    echo 0x98B02AC > $DCC_PATH/config
    echo 0x98B0400 > $DCC_PATH/config
    echo 0x98B0404 > $DCC_PATH/config
    echo 0x98B0408 > $DCC_PATH/config
    echo 0x9802028 > $DCC_PATH/config

    #CDSP RSCp
    echo 0x80A4010 > $DCC_PATH/config
    echo 0x80A4014 > $DCC_PATH/config
    echo 0x80A4018 > $DCC_PATH/config
    echo 0x80A4030 > $DCC_PATH/config
    echo 0x80A4038 > $DCC_PATH/config
    echo 0x80A4040 > $DCC_PATH/config
    echo 0x80A4048 > $DCC_PATH/config
    echo 0x80A40D0 > $DCC_PATH/config
    echo 0x80A4210 > $DCC_PATH/config
    echo 0x80A4230 > $DCC_PATH/config
    echo 0x80A4250 > $DCC_PATH/config
    echo 0x80A4270 > $DCC_PATH/config
    echo 0x80A4290 > $DCC_PATH/config
    echo 0x80A42B0 > $DCC_PATH/config
    echo 0x80A4208 > $DCC_PATH/config
    echo 0x80A4228 > $DCC_PATH/config
    echo 0x80A4248 > $DCC_PATH/config
    echo 0x80A4268 > $DCC_PATH/config
    echo 0x80A4288 > $DCC_PATH/config
    echo 0x80A42A8 > $DCC_PATH/config
    echo 0x80A420C > $DCC_PATH/config
    echo 0x80A422C > $DCC_PATH/config
    echo 0x80A424C > $DCC_PATH/config
    echo 0x80A426C > $DCC_PATH/config
    echo 0x80A428C > $DCC_PATH/config
    echo 0x80A42AC > $DCC_PATH/config
    echo 0x80A4404 > $DCC_PATH/config
    echo 0x80A4408 > $DCC_PATH/config
    echo 0x80A4400 > $DCC_PATH/config
    echo 0x80A4D04 > $DCC_PATH/config

    #QDSP6 RSC

    echo 0x83B0010 > $DCC_PATH/config
    echo 0x83B0014 > $DCC_PATH/config
    echo 0x83B0018 > $DCC_PATH/config
    echo 0x83B0210 > $DCC_PATH/config
    echo 0x83B0230 > $DCC_PATH/config
    echo 0x83B0250 > $DCC_PATH/config
    echo 0x83B0270 > $DCC_PATH/config
    echo 0x83B0290 > $DCC_PATH/config
    echo 0x83B02B0 > $DCC_PATH/config
    echo 0x83B0208 > $DCC_PATH/config
    echo 0x83B0228 > $DCC_PATH/config
    echo 0x83B0248 > $DCC_PATH/config
    echo 0x83B0268 > $DCC_PATH/config
    echo 0x83B0288 > $DCC_PATH/config
    echo 0x83B02A8 > $DCC_PATH/config
    echo 0x83B020C > $DCC_PATH/config
    echo 0x83B022C > $DCC_PATH/config
    echo 0x83B024C > $DCC_PATH/config
    echo 0x83B026C > $DCC_PATH/config
    echo 0x83B028C > $DCC_PATH/config
    echo 0x83B02AC > $DCC_PATH/config
    echo 0x83B0400 > $DCC_PATH/config
    echo 0x83B0404 > $DCC_PATH/config
    echo 0x83B0408 > $DCC_PATH/config


    #CDSP PDC
    echo 0xb2b0010 > $DCC_PATH/config
    echo 0xb2b0900 > $DCC_PATH/config
    echo 0xb2b1020 > $DCC_PATH/config
    echo 0xb2b1024 > $DCC_PATH/config
    echo 0xb2b1030 > $DCC_PATH/config
    echo 0xb2b103c > $DCC_PATH/config
    echo 0xb2b1200 > $DCC_PATH/config
    echo 0xb2b1204 > $DCC_PATH/config
    echo 0xb2b1208 > $DCC_PATH/config
    echo 0xb2b4510 > $DCC_PATH/config
    echo 0xb2b4514 > $DCC_PATH/config
    echo 0xb2b4520 > $DCC_PATH/config

    #QDSP6 General
    echo 0x8300468 > $DCC_PATH/config
    echo 0x8302000 > $DCC_PATH/config
    echo 0x8390380 32 > $DCC_PATH/config
}

config_lagoon_dcc_lpass_rsc(){
    #Audio PDC
    echo 0xb250010 > $DCC_PATH/config

    echo 0xb250900 > $DCC_PATH/config

    echo 0xb251020 > $DCC_PATH/config
    echo 0xb251024 > $DCC_PATH/config
    echo 0xb251030 > $DCC_PATH/config
    echo 0xb25103c > $DCC_PATH/config
    echo 0xb251200 > $DCC_PATH/config
    echo 0xb251204 > $DCC_PATH/config
    echo 0xb251208 > $DCC_PATH/config
    echo 0xb254510 > $DCC_PATH/config
    echo 0xb254514 > $DCC_PATH/config
    echo 0xb254520 > $DCC_PATH/config

    #LPASS General
    echo 0x3000468 > $DCC_PATH/config
    echo 0x3002000 > $DCC_PATH/config
    echo 0x3002004 > $DCC_PATH/config
    echo 0x3090380 32 > $DCC_PATH/config
    echo 0x62402028  > $DCC_PATH/config

    #WDOG
    echo 0x8384004 5 > $DCC_PATH/config
    echo 0x08300304 > $DCC_PATH/config

    #RSCp
    echo 0x62900010 > $DCC_PATH/config
    echo 0x62900014 > $DCC_PATH/config
    echo 0x62900018 > $DCC_PATH/config
    echo 0x62900030 > $DCC_PATH/config
    echo 0x62900038 > $DCC_PATH/config
    echo 0x62900040 > $DCC_PATH/config
    echo 0x62900048 > $DCC_PATH/config
    echo 0x629000D0 > $DCC_PATH/config
    echo 0x62900210 > $DCC_PATH/config
    echo 0x62900230 > $DCC_PATH/config
    echo 0x62900250 > $DCC_PATH/config
    echo 0x62900270 > $DCC_PATH/config
    echo 0x62900290 > $DCC_PATH/config
    echo 0x629002B0 > $DCC_PATH/config
    echo 0x62900208 > $DCC_PATH/config
    echo 0x62900228 > $DCC_PATH/config
    echo 0x62900248 > $DCC_PATH/config
    echo 0x62900268 > $DCC_PATH/config
    echo 0x62900288 > $DCC_PATH/config
    echo 0x629002A8 > $DCC_PATH/config
    echo 0x6290020C > $DCC_PATH/config
    echo 0x6290022C > $DCC_PATH/config
    echo 0x6290024C > $DCC_PATH/config
    echo 0x6290026C > $DCC_PATH/config
    echo 0x6290028C > $DCC_PATH/config
    echo 0x629002AC > $DCC_PATH/config
    echo 0x62900404 > $DCC_PATH/config
    echo 0x62900408 > $DCC_PATH/config
    echo 0x62900400 > $DCC_PATH/config
    echo 0x62900D04 > $DCC_PATH/config

    #RSCc
    echo 0x624B0010 > $DCC_PATH/config
    echo 0x624B0014 > $DCC_PATH/config
    echo 0x624B0018 > $DCC_PATH/config
    echo 0x624B0210 > $DCC_PATH/config
    echo 0x624B0230 > $DCC_PATH/config
    echo 0x624B0250 > $DCC_PATH/config
    echo 0x624B0270 > $DCC_PATH/config
    echo 0x624B0290 > $DCC_PATH/config
    echo 0x624B02B0 > $DCC_PATH/config
    echo 0x624B0208 > $DCC_PATH/config
    echo 0x624B0228 > $DCC_PATH/config
    echo 0x624B0248 > $DCC_PATH/config
    echo 0x624B0268 > $DCC_PATH/config
    echo 0x624B0288 > $DCC_PATH/config
    echo 0x624B02A8 > $DCC_PATH/config
    echo 0x624B020C > $DCC_PATH/config
    echo 0x624B022C > $DCC_PATH/config
    echo 0x624B024C > $DCC_PATH/config
    echo 0x624B026C > $DCC_PATH/config
    echo 0x624B028C > $DCC_PATH/config
    echo 0x624B02AC > $DCC_PATH/config
    echo 0x624B0400 > $DCC_PATH/config
    echo 0x624B0404 > $DCC_PATH/config
    echo 0x624B0408 > $DCC_PATH/config
}

config_lagoon_dcc_mss_rsc(){
    #MSS RSCp
    echo 0x4200010 > $DCC_PATH/config
    echo 0x4200014 > $DCC_PATH/config
    echo 0x4200018 > $DCC_PATH/config
    echo 0x4200030 > $DCC_PATH/config
    echo 0x4200038 > $DCC_PATH/config
    echo 0x4200040 > $DCC_PATH/config
    echo 0x4200048 > $DCC_PATH/config
    echo 0x42000D0 > $DCC_PATH/config
    echo 0x4200210 > $DCC_PATH/config
    echo 0x4200230 > $DCC_PATH/config
    echo 0x4200250 > $DCC_PATH/config
    echo 0x4200270 > $DCC_PATH/config
    echo 0x4200290 > $DCC_PATH/config
    echo 0x42002B0 > $DCC_PATH/config
    echo 0x4200208 > $DCC_PATH/config
    echo 0x4200228 > $DCC_PATH/config
    echo 0x4200248 > $DCC_PATH/config
    echo 0x4200268 > $DCC_PATH/config
    echo 0x4200288 > $DCC_PATH/config
    echo 0x42002A8 > $DCC_PATH/config
    echo 0x420020C > $DCC_PATH/config
    echo 0x420022C > $DCC_PATH/config
    echo 0x420024C > $DCC_PATH/config
    echo 0x420026C > $DCC_PATH/config
    echo 0x420028C > $DCC_PATH/config
    echo 0x42002AC > $DCC_PATH/config
    echo 0x4200404 > $DCC_PATH/config
    echo 0x4200408 > $DCC_PATH/config
    echo 0x4200400 > $DCC_PATH/config
    echo 0x4200D04 > $DCC_PATH/config

    #MSS RSCc

    echo 0x4130010 > $DCC_PATH/config
    echo 0x4130014 > $DCC_PATH/config
    echo 0x4130018 > $DCC_PATH/config
    echo 0x4130210 > $DCC_PATH/config
    echo 0x4130230 > $DCC_PATH/config
    echo 0x4130250 > $DCC_PATH/config
    echo 0x4130270 > $DCC_PATH/config
    echo 0x4130290 > $DCC_PATH/config
    echo 0x41302B0 > $DCC_PATH/config
    echo 0x4130208 > $DCC_PATH/config
    echo 0x4130228 > $DCC_PATH/config
    echo 0x4130248 > $DCC_PATH/config
    echo 0x4130268 > $DCC_PATH/config
    echo 0x4130288 > $DCC_PATH/config
    echo 0x41302A8 > $DCC_PATH/config
    echo 0x413020C > $DCC_PATH/config
    echo 0x413022C > $DCC_PATH/config
    echo 0x413024C > $DCC_PATH/config
    echo 0x413026C > $DCC_PATH/config
    echo 0x413028C > $DCC_PATH/config
    echo 0x41302AC > $DCC_PATH/config
    echo 0x4130400 > $DCC_PATH/config
    echo 0x4130404 > $DCC_PATH/config
    echo 0x4130408 > $DCC_PATH/config

    #MSS PDC
    echo 0xb2c0010 > $DCC_PATH/config
    echo 0xb2c0014 > $DCC_PATH/config
    echo 0xb2c0900 > $DCC_PATH/config
    echo 0xb2c0904 > $DCC_PATH/config
    echo 0xb2c1020 > $DCC_PATH/config
    echo 0xb2c1024 > $DCC_PATH/config
    echo 0xb2c1030 > $DCC_PATH/config
    echo 0xb2c1200 > $DCC_PATH/config
    echo 0xb2c1204 > $DCC_PATH/config
    echo 0xb2c1208 > $DCC_PATH/config
    echo 0xb2c4510 > $DCC_PATH/config
    echo 0xb2c4514 > $DCC_PATH/config
    echo 0xb2c4520 > $DCC_PATH/config
    echo 0x18A008 > $DCC_PATH/config

}

config_lagoon_dcc_noc(){
    #A1NOC
    echo 0x16e0000 > $DCC_PATH/config
    echo 0x16e0004 > $DCC_PATH/config
    echo 0x16e0300 > $DCC_PATH/config
    echo 0x16E0400 > $DCC_PATH/config
    echo 0x16e0408 > $DCC_PATH/config
    echo 0x16e0410 > $DCC_PATH/config
    echo 0x16e0420 > $DCC_PATH/config
    echo 0x16e0424 > $DCC_PATH/config
    echo 0x16e0428 > $DCC_PATH/config
    echo 0x16e042c > $DCC_PATH/config
    echo 0x16e0430 > $DCC_PATH/config
    echo 0x16e0434 > $DCC_PATH/config
    echo 0x16e0438 > $DCC_PATH/config
    echo 0x16e043c > $DCC_PATH/config
    echo 0x16e0688 > $DCC_PATH/config
    echo 0x16e0690 > $DCC_PATH/config
    echo 0x16e0700 > $DCC_PATH/config

    #A2NOC
    echo 0x1700204 > $DCC_PATH/config
    echo 0x1700240 > $DCC_PATH/config
    echo 0x1700248 > $DCC_PATH/config
    echo 0x1700288 > $DCC_PATH/config
    echo 0x1700290 > $DCC_PATH/config
    echo 0x1700300 > $DCC_PATH/config
    echo 0x1700304 > $DCC_PATH/config
    echo 0x1700308 > $DCC_PATH/config
    echo 0x170030c > $DCC_PATH/config
    echo 0x1700310 > $DCC_PATH/config
    echo 0x1700400 > $DCC_PATH/config
    echo 0x1700404 > $DCC_PATH/config
    echo 0x1700488 > $DCC_PATH/config
    echo 0x1700490 > $DCC_PATH/config
    echo 0x1700500 > $DCC_PATH/config
    echo 0x1700504 > $DCC_PATH/config
    echo 0x1700508 > $DCC_PATH/config
    echo 0x170050c > $DCC_PATH/config
    echo 0x1700c00 > $DCC_PATH/config
    echo 0x1700c04 > $DCC_PATH/config
    echo 0x1700c08 > $DCC_PATH/config
    echo 0x1700c10 > $DCC_PATH/config
    echo 0x1700c20 > $DCC_PATH/config
    echo 0x1700c24 > $DCC_PATH/config
    echo 0x1700c28 > $DCC_PATH/config
    echo 0x1700c2c > $DCC_PATH/config
    echo 0x1700c30 > $DCC_PATH/config
    echo 0x1700c34 > $DCC_PATH/config
    echo 0x1700c38 > $DCC_PATH/config
    echo 0x1700c3c > $DCC_PATH/config

    #SNOC
    echo 0x1620000 > $DCC_PATH/config
    echo 0x1620004 > $DCC_PATH/config
    echo 0x1620008 > $DCC_PATH/config
    echo 0x1620010 > $DCC_PATH/config
    echo 0x1620020 > $DCC_PATH/config
    echo 0x1620024 > $DCC_PATH/config
    echo 0x1620028 > $DCC_PATH/config
    echo 0x162002c > $DCC_PATH/config
    echo 0x1620030 > $DCC_PATH/config
    echo 0x1620034 > $DCC_PATH/config
    echo 0x1620038 > $DCC_PATH/config
    echo 0x162003c > $DCC_PATH/config
    echo 0x1620100 > $DCC_PATH/config
    echo 0x1620104 > $DCC_PATH/config
    echo 0x1620108 > $DCC_PATH/config
    echo 0x1620110 > $DCC_PATH/config
    echo 0x1620200 > $DCC_PATH/config
    echo 0x1620204 > $DCC_PATH/config
    echo 0x1620240 > $DCC_PATH/config
    echo 0x1620248 > $DCC_PATH/config
    echo 0x1620288 > $DCC_PATH/config
    echo 0x162028c > $DCC_PATH/config
    echo 0x1620290 > $DCC_PATH/config
    echo 0x1620294 > $DCC_PATH/config
    echo 0x16202a8 > $DCC_PATH/config
    echo 0x16202ac > $DCC_PATH/config
    echo 0x16202b0 > $DCC_PATH/config
    echo 0x16202b4 > $DCC_PATH/config
    echo 0x1620300 > $DCC_PATH/config
    echo 0x1620400 > $DCC_PATH/config
    echo 0x1620404 > $DCC_PATH/config
    echo 0x1620488 > $DCC_PATH/config
    echo 0x1620490 > $DCC_PATH/config
    echo 0x1620500 > $DCC_PATH/config
    echo 0x1620504 > $DCC_PATH/config
    echo 0x1620508 > $DCC_PATH/config
    echo 0x162050c > $DCC_PATH/config
    echo 0x1620510 > $DCC_PATH/config
    echo 0x1620600 > $DCC_PATH/config
    echo 0x1620604 > $DCC_PATH/config
    echo 0x1620688 > $DCC_PATH/config
    echo 0x1620690 > $DCC_PATH/config
    echo 0x1620700 > $DCC_PATH/config
    echo 0x1620704 > $DCC_PATH/config
    echo 0x1620708 > $DCC_PATH/config
    echo 0x162070c > $DCC_PATH/config
    echo 0x1620710 > $DCC_PATH/config
    echo 0x1620800 > $DCC_PATH/config
    echo 0x1620804 > $DCC_PATH/config
    echo 0x1620900 > $DCC_PATH/config
    echo 0x1620a00 > $DCC_PATH/config
    echo 0x1620a04 > $DCC_PATH/config
    echo 0x1620b00 > $DCC_PATH/config
    echo 0x1620b04 > $DCC_PATH/config
    echo 0x1639000 > $DCC_PATH/config
    echo 0x1639004 > $DCC_PATH/config

    #LPASS AGNOC
    echo 0x3c41800 > $DCC_PATH/config
    echo 0x3c41804 > $DCC_PATH/config
    echo 0x3c41880 > $DCC_PATH/config
    echo 0x3c41888 > $DCC_PATH/config
    echo 0x3c41890 > $DCC_PATH/config
    echo 0x3c41900 > $DCC_PATH/config
    echo 0x3c41a00 > $DCC_PATH/config
    echo 0x3c41a04 > $DCC_PATH/config
    echo 0x3c41a40 > $DCC_PATH/config
    echo 0x3c41a48 > $DCC_PATH/config
    echo 0x3c41c00 > $DCC_PATH/config
    echo 0x3c41c04 > $DCC_PATH/config
    echo 0x3c41d00 > $DCC_PATH/config
    echo 0x3c42680 > $DCC_PATH/config
    echo 0x3c42684 > $DCC_PATH/config
    echo 0x3c42688 > $DCC_PATH/config
    echo 0x3c42690 > $DCC_PATH/config
    echo 0x3c42698 > $DCC_PATH/config
    echo 0x3c426a0 > $DCC_PATH/config
    echo 0x3c426a4 > $DCC_PATH/config
    echo 0x3c426a8 > $DCC_PATH/config
    echo 0x3c426ac > $DCC_PATH/config
    echo 0x3c426b0 > $DCC_PATH/config
    echo 0x3c426b4 > $DCC_PATH/config
    echo 0x3c426b8 > $DCC_PATH/config
    echo 0x3c426bc > $DCC_PATH/config

    #GEMNOC
    echo 0x9681010 > $DCC_PATH/config
    echo 0x9681014 > $DCC_PATH/config
    echo 0x9681018 > $DCC_PATH/config
    echo 0x968101c > $DCC_PATH/config
    echo 0x9681020 > $DCC_PATH/config
    echo 0x9681024 > $DCC_PATH/config
    echo 0x9681028 > $DCC_PATH/config
    echo 0x968102c > $DCC_PATH/config
    echo 0x9681030 > $DCC_PATH/config
    echo 0x9681034 > $DCC_PATH/config
    echo 0x968103c > $DCC_PATH/config
    echo 0x9692000 > $DCC_PATH/config
    echo 0x9692004 > $DCC_PATH/config
    echo 0x9692008 > $DCC_PATH/config
    echo 0x9692040 > $DCC_PATH/config
    echo 0x9692048 > $DCC_PATH/config
    echo 0x9695000 > $DCC_PATH/config
    echo 0x9695004 > $DCC_PATH/config
    echo 0x9695080 > $DCC_PATH/config
    echo 0x9695084 > $DCC_PATH/config
    echo 0x9695088 > $DCC_PATH/config
    echo 0x969508c > $DCC_PATH/config
    echo 0x9695090 > $DCC_PATH/config
    echo 0x9695094 > $DCC_PATH/config
    echo 0x96950a0 > $DCC_PATH/config
    echo 0x96950a8 > $DCC_PATH/config
    echo 0x96950b0 > $DCC_PATH/config
    echo 0x9695100 > $DCC_PATH/config
    echo 0x9695104 > $DCC_PATH/config
    echo 0x9695108 > $DCC_PATH/config
    echo 0x969510c > $DCC_PATH/config
    echo 0x9695110 > $DCC_PATH/config
    echo 0x9695114 > $DCC_PATH/config
    echo 0x9695118 > $DCC_PATH/config
    echo 0x969511c > $DCC_PATH/config
    echo 0x9696000 > $DCC_PATH/config
    echo 0x9696004 > $DCC_PATH/config
    echo 0x9696080 > $DCC_PATH/config
    echo 0x9696088 > $DCC_PATH/config
    echo 0x9696090 > $DCC_PATH/config
    echo 0x9696100 > $DCC_PATH/config
    echo 0x9696104 > $DCC_PATH/config
    echo 0x9696108 > $DCC_PATH/config
    echo 0x969610c > $DCC_PATH/config
    echo 0x9696114 > $DCC_PATH/config
    echo 0x9696118 > $DCC_PATH/config
    echo 0x969611c > $DCC_PATH/config
    echo 0x9698000 > $DCC_PATH/config
    echo 0x9698004 > $DCC_PATH/config
    echo 0x9698008 > $DCC_PATH/config
    echo 0x9698010 > $DCC_PATH/config
    echo 0x9698100 > $DCC_PATH/config
    echo 0x9698104 > $DCC_PATH/config
    echo 0x9698108 > $DCC_PATH/config
    echo 0x9698110 > $DCC_PATH/config
    echo 0x9698118 > $DCC_PATH/config
    echo 0x9698120 > $DCC_PATH/config
    echo 0x9698124 > $DCC_PATH/config
    echo 0x9698128 > $DCC_PATH/config
    echo 0x969812c > $DCC_PATH/config
    echo 0x9698130 > $DCC_PATH/config
    echo 0x9698134 > $DCC_PATH/config
    echo 0x9698138 > $DCC_PATH/config
    echo 0x969813c > $DCC_PATH/config
    echo 0x9698200 > $DCC_PATH/config
    echo 0x9698204 > $DCC_PATH/config
    echo 0x9698240 > $DCC_PATH/config
    echo 0x9698244 > $DCC_PATH/config
    echo 0x9698248 > $DCC_PATH/config
    echo 0x969824c > $DCC_PATH/config
    echo 0x1B9064 > $DCC_PATH/config
    echo 0x1B906C > $DCC_PATH/config

}

config_lagoon_dcc_gcc(){
    #GCC
    echo 0x100000 13 > $DCC_PATH/config
    echo 0x100040 > $DCC_PATH/config

    echo 0x101000 13 > $DCC_PATH/config
    echo 0x10103c > $DCC_PATH/config
    echo 0x101040 > $DCC_PATH/config
    echo 0x102000 13 > $DCC_PATH/config
    echo 0x10203c > $DCC_PATH/config
    echo 0x102040 > $DCC_PATH/config
    echo 0x103000 13 > $DCC_PATH/config
    echo 0x10303c > $DCC_PATH/config
    echo 0x103040 > $DCC_PATH/config
    echo 0x10401c > $DCC_PATH/config
    echo 0x105008 > $DCC_PATH/config
    echo 0x10504c > $DCC_PATH/config
    echo 0x113000 > $DCC_PATH/config
    echo 0x113004 > $DCC_PATH/config
    echo 0x113008 > $DCC_PATH/config


}

config_lagoon_dcc_l3_rsc(){
}

config_lagoon_dcc_pimem()
{
    echo 0x610100 11 > $DCC_PATH/config
}

config_lagoon_dcc_misc()
{
    echo 0xC2A2040 > $DCC_PATH/config
    #LPASS RSC
    echo 0x3500010 > $DCC_PATH/config
    echo 0x3500014 > $DCC_PATH/config
    echo 0x3500018 > $DCC_PATH/config
    echo 0x3500030 > $DCC_PATH/config
    echo 0x3500038 > $DCC_PATH/config
    echo 0x3500040 > $DCC_PATH/config
    echo 0x3500048 > $DCC_PATH/config
    echo 0x35000d0 > $DCC_PATH/config
    echo 0x3500208 > $DCC_PATH/config
    echo 0x350020c > $DCC_PATH/config
    echo 0x3500210 > $DCC_PATH/config
    echo 0x3500228 > $DCC_PATH/config
    echo 0x350022c > $DCC_PATH/config
    echo 0x3500230 > $DCC_PATH/config
    echo 0x3500248 > $DCC_PATH/config
    echo 0x350024c > $DCC_PATH/config
    echo 0x3500250 > $DCC_PATH/config
    echo 0x3500268 > $DCC_PATH/config
    echo 0x350026c > $DCC_PATH/config
    echo 0x3500270 > $DCC_PATH/config
    echo 0x3500288 > $DCC_PATH/config
    echo 0x350028c > $DCC_PATH/config
    echo 0x3500290 > $DCC_PATH/config
    echo 0x35002a8 > $DCC_PATH/config
    echo 0x35002ac > $DCC_PATH/config
    echo 0x35002b0 > $DCC_PATH/config
    echo 0x3500400 > $DCC_PATH/config
    echo 0x3500404 > $DCC_PATH/config
    echo 0x3500408 > $DCC_PATH/config
    echo 0x3500d04 > $DCC_PATH/config

    #LPASS RSCc
    echo 0x30b0010 > $DCC_PATH/config
    echo 0x30b0014 > $DCC_PATH/config
    echo 0x30b0018 > $DCC_PATH/config
    echo 0x30b0208 > $DCC_PATH/config
    echo 0x30b020c > $DCC_PATH/config
    echo 0x30b0210 > $DCC_PATH/config
    echo 0x30b0228 > $DCC_PATH/config
    echo 0x30b022c > $DCC_PATH/config
    echo 0x30b0230 > $DCC_PATH/config
    echo 0x30b0248 > $DCC_PATH/config
    echo 0x30b024c > $DCC_PATH/config
    echo 0x30b0250 > $DCC_PATH/config
    echo 0x30b0268 > $DCC_PATH/config
    echo 0x30b026c > $DCC_PATH/config
    echo 0x30b0270 > $DCC_PATH/config
    echo 0x30b0288 > $DCC_PATH/config
    echo 0x30b028c > $DCC_PATH/config
    echo 0x30b0290 > $DCC_PATH/config
    echo 0x30b02a8 > $DCC_PATH/config
    echo 0x30b02ac > $DCC_PATH/config
    echo 0x30b02b0 > $DCC_PATH/config
    echo 0x30b0400 > $DCC_PATH/config
    echo 0x30b0404 > $DCC_PATH/config
    echo 0x30b0408 > $DCC_PATH/config

    #Core status and NMI for modem / Lpass / Turing
    echo 0x8300044 > $DCC_PATH/config
    echo 0x8302028 > $DCC_PATH/config
    echo 0x3002028 > $DCC_PATH/config
    echo 0x3000044 > $DCC_PATH/config
    echo 0x4082028 > $DCC_PATH/config
    echo 0x4080044 > $DCC_PATH/config
}

config_lagoon_dcc_gic()
{
    echo 0x17A00104 29 > $DCC_PATH/config
    echo 0x17A00204 29 > $DCC_PATH/config
}

config_lagoon_dcc_apps_rsc_pdc()
{
    #APPS RSC
    echo 0x18200010 > $DCC_PATH/config
    echo 0x18200030 > $DCC_PATH/config
    echo 0x18200038 > $DCC_PATH/config
    echo 0x18200048 > $DCC_PATH/config
    echo 0x18220038 > $DCC_PATH/config
    echo 0x18220040 > $DCC_PATH/config
    echo 0x182200D0 > $DCC_PATH/config
    echo 0x18220010 > $DCC_PATH/config
    echo 0x18220030 > $DCC_PATH/config
    echo 0x18200400 > $DCC_PATH/config
    echo 0x18200404 > $DCC_PATH/config
    echo 0x18200408 > $DCC_PATH/config

    #RPMH PDC
    echo 0xb201020 > $DCC_PATH/config
    echo 0xb201024 > $DCC_PATH/config
    echo 0xb20103c > $DCC_PATH/config
    echo 0xb204510 > $DCC_PATH/config
    echo 0xb204514 > $DCC_PATH/config
    echo 0xb204520 > $DCC_PATH/config

}
config_lagoon_dcc_gcc_other()
{

}

# Function to send ASYNC package in TPDA
lagoon_dcc_async_package()
{
    echo 0x06004FB0 0xc5acce55 > $DCC_PATH/config_write
    echo 0x0600408c 0xff > $DCC_PATH/config_write
    echo 0x06004FB0 0x0 > $DCC_PATH/config_write
}

# Function lagoon DCC configuration
enable_lagoon_dcc_config()
{
    DCC_PATH="/sys/bus/platform/devices/109f000.dcc_v2"
    soc_version=`cat /sys/devices/soc0/revision`
    soc_version=${soc_version/./}

    if [ ! -d $DCC_PATH ]; then
        echo "DCC does not exist on this build."
        return
    fi

    #DCC will trigger in following order LL4 -> LL3
    echo 0 > $DCC_PATH/enable
    echo 1 > $DCC_PATH/config_reset
    echo 4 > $DCC_PATH/curr_list
    echo cap > $DCC_PATH/func_type
    echo sram > $DCC_PATH/data_sink
    config_lagoon_dcc_lpm
    config_lagoon_dcc_apps_rsc_pdc
    config_lagoon_dcc_core
    config_lagoon_dcc_osm
    config_lagoon_dcc_gemnoc
    config_lagoon_dcc_noc

    config_lagoon_dcc_pimem

    config_lagoon_dcc_ddr
    config_lagoon_dcc_ddr

    echo 1 > /sys/bus/coresight/devices/coresight-tpdm-dcc/enable_source
    echo 3 > $DCC_PATH/curr_list
    echo cap > $DCC_PATH/func_type
    echo atb > $DCC_PATH/data_sink
    lagoon_dcc_async_package
    config_lagoon_dcc_rsc_tcs
    config_lagoon_dcc_lpass_rsc
    config_lagoon_dcc_mss_rsc
    #config_lagoon_dcc_gpu
    #config_lagoon_dcc_gcc
    #config_lagoon_dcc_l3_rsc
    #config_lagoon_dcc_gcc_other
    #config_lagoon_dcc_misc
    #config_lagoon_dcc_gic

    echo  1 > $DCC_PATH/enable
}

enable_lagoon_pcu_pll_hw_events()
{
}

enable_lagoon_stm_hw_events()
{
   QMI_HELPER=/system/vendor/bin/qdss_qmi_helper
   #enable_lagoon_pcu_pll_hw_events
}

enable_lagoon_core_hang_config()
{
    CORE_PATH_SILVER="/sys/devices/system/cpu/hang_detect_silver"
    CORE_PATH_GOLD="/sys/devices/system/cpu/hang_detect_gold"
    if [ ! -d $CORE_PATH ]; then
        echo "CORE hang does not exist on this build."
        return
    fi

    #set the threshold to max
    echo 0xffffffff > $CORE_PATH_SILVER/threshold
    echo 0xffffffff > $CORE_PATH_GOLD/threshold

    #To enable core hang detection
    #It's a boolean variable. Do not use Hex value to enable/disable
    echo 1 > $CORE_PATH_SILVER/enable
    echo 1 > $CORE_PATH_GOLD/enable
}


ftrace_disable=`getprop persist.debug.ftrace_events_disable`
srcenable="enable"
sinkenable="curr_sink"
enable_lagoon_debug()
{
    echo "lagoon debug"
    srcenable="enable_source"
    sinkenable="enable_sink"
    echo "Enabling STM events on lagoon."
    enable_stm_events_lagoon
    if [ "$ftrace_disable" != "Yes" ]; then
        enable_ftrace_event_tracing_lagoon
    fi
    enable_lagoon_dcc_config
    enable_lagoon_core_hang_config
    enable_lagoon_stm_hw_events
}
